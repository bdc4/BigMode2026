/// oPlayer : Step
/// Driving + effects + hard no-overlap + crash lock + high-speed spin-out
/// NEW: bounce launches player perpendicular away from the wall

// ------------------------------------------------------------
// Helper: launch away perpendicular to the wall (AABB normal)
// ------------------------------------------------------------
function bounce_launch_away(_hit, _impact_speed)
{
    // Player bbox (current)
    var pL = bbox_left,  pR = bbox_right, pT = bbox_top, pB = bbox_bottom;

    // Solid bbox
    var sL = _hit.bbox_left, sR = _hit.bbox_right, sT = _hit.bbox_top, sB = _hit.bbox_bottom;

    // Overlaps (penetration depth)
    var oL = pR - sL;
    var oR = sR - pL;
    var oT = pB - sT;
    var oB = sB - pT;

    // Choose smallest push => wall normal
    var mino = min(min(oL, oR), min(oT, oB));

    var nx = 0, ny = 0;
    var push = 1;

    if (mino == oL) { nx = -1; x -= oL + push; }
    else if (mino == oR) { nx =  1; x += oR + push; }
    else if (mino == oT) { ny = -1; y -= oT + push; }
    else { ny =  1; y += oB + push; }

    // Launch straight out
    var out_speed = max(_impact_speed, min_bounce_speed) * bounce_loss;

    hsp = nx * out_speed;
    vsp = ny * out_speed;
}

function is_on_drivable()
{
    var cx = (bbox_left + bbox_right) * 0.5;
    var cy = (bbox_top + bbox_bottom) * 0.5;

    // sample center + 4 corners
    if (tilemap_get_at_pixel(road_map_id, cx, cy) != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_left,  bbox_top)    != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_right, bbox_top)    != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_left,  bbox_bottom) != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_right, bbox_bottom) != 0) return true;

    return false;
}



// ------------------------------------------------------------
// INPUT (disabled during crash lock / spin-out)
// ------------------------------------------------------------
var spinning = (spin_time > 0);
var locked = (crash_timer > 0) || spinning;

var throttle = (!locked) && keyboard_check(vk_space);

var turn = 0;
if (!locked) {
    turn = (keyboard_check(vk_left)  || keyboard_check(ord("A")))
         - (keyboard_check(vk_right) || keyboard_check(ord("D")));
}

if (crash_timer > 0) crash_timer -= 1;



// ------------------------------------------------------------
// TURNING (changes facing)
// ------------------------------------------------------------
if (turn != 0) {
    var spd = point_distance(0, 0, hsp, vsp);
    var turn_scale = clamp(spd / max_speed, 0.25, 1.0);
    facing += turn * turn_rate * turn_scale;
}
facing = (facing mod 360 + 360) mod 360;

// ------------------------------------------------------------
// THRUST (accelerate toward tip)
// ------------------------------------------------------------
if (throttle) {
    var thrust_dir = facing + tip_angle_offset;
    hsp += lengthdir_x(engine_accel, thrust_dir);
    vsp += lengthdir_y(engine_accel, thrust_dir);
}

// ------------------------------------------------------------
// DRAG (with randomness, smoothed)
// ------------------------------------------------------------
var drag_target = drag_base + random_range(-drag_jitter, drag_jitter);
drag_cur = lerp(drag_cur, drag_target, drag_smooth);

hsp *= (1 - drag_cur);
vsp *= (1 - drag_cur);

// ------------------------------------------------------------
// OFF-ROAD DRAG (if not on "Drivable" tile layer)
// ------------------------------------------------------------
if (!is_on_drivable()) {
    hsp *= (1 - road_drag_extra);
    vsp *= (1 - road_drag_extra);
}


// ------------------------------------------------------------
// CLAMP SPEED MAGNITUDE
// ------------------------------------------------------------
var vlen = point_distance(0, 0, hsp, vsp);
if (vlen > max_speed) {
    var s = max_speed / vlen;
    hsp *= s;
    vsp *= s;
    vlen = max_speed;
}

// ------------------------------------------------------------
// MOVE (sub-stepped) + perpendicular launch bounce + hard no-overlap guarantee
// ------------------------------------------------------------
var crashed = false;
var impact_vlen = vlen; // keep pre-collision speed for crash effects

var step_size = 1;
var steps = ceil(max(abs(hsp), abs(vsp)) / step_size);
if (steps < 1) steps = 1;

var dx = hsp / steps;
var dy = vsp / steps;

for (var i = 0; i < steps; i++)
{
    // --- X ---
    x += dx;
    var hit = instance_place(x, y, all);
    if (hit != noone && hit.solid) {
        crashed = true;
        x -= dx;

        // launch away perpendicular to wall
        var impact_speed = point_distance(0, 0, hsp, vsp);
        bounce_launch_away(hit, impact_speed);

        // recompute substep deltas using new velocity
        dx = hsp / steps;
        dy = vsp / steps;
    }

    // --- Y ---
    y += dy;
    hit = instance_place(x, y, all);
    if (hit != noone && hit.solid) {
        crashed = true;
        y -= dy;

        // launch away perpendicular to wall
        var impact_speed2 = point_distance(0, 0, hsp, vsp);
        bounce_launch_away(hit, impact_speed2);

        dx = hsp / steps;
        dy = vsp / steps;
    }
}

// Never end inside solids — if still overlapping, launch away using the same normal logic
var final_hit = collision_rectangle(
    bbox_left, bbox_top, bbox_right, bbox_bottom,
    all, false, true
);

if (final_hit != noone && final_hit.solid)
{
    crashed = true;
    var impact_speed3 = max(impact_vlen, min_bounce_speed);
    bounce_launch_away(final_hit, impact_speed3);
}

// ------------------------------------------------------------
// CRASH EFFECTS (lock controls; spin-out only at high speed)
// ------------------------------------------------------------
if (crashed)
{
    if (crash_timer <= 0) crash_timer = crash_lock_frames;

    // flip heading by impact ratio (0..180)
    var r = clamp(impact_vlen / max_speed, 0, 1);
    var flip = 180 * r;
    facing = (facing + flip) mod 360;

    // high-speed spin-out only (timer-based ~1 second)
    var spin_threshold = 0.75;
    if (r >= spin_threshold && spin_time <= 0) {
        var t = clamp((r - spin_threshold) / (1 - spin_threshold), 0, 1);

        spin_time = spin_time_max;
        spin_dir = choose(-1, 1);

        // aggressive (tune)
        spin_start_rate = lerp(18, 60, t);
    }

    // optional "thud" feel (affects the bounce-launch speed slightly after)
    hsp *= 0.85;
    vsp *= 0.85;
}

// Recompute vlen after movement/collision changes
vlen = point_distance(0, 0, hsp, vsp);

// ------------------------------------------------------------
// SPIN-OUT UPDATE (auto-rotate; controls remain locked while active)
// ------------------------------------------------------------
if (spin_time > 0) {
    var u = spin_time / spin_time_max; // 1..0
    var rate = spin_start_rate * u;    // ease out

    facing = (facing + spin_dir * rate) mod 360;

    spin_time -= 1;
    if (spin_time <= 0) {
        spin_time = 0;
        spin_start_rate = 0;
    }
}

// ------------------------------------------------------------
// SMOOTH SPRITE ROTATION
// ------------------------------------------------------------
var diff = angle_difference(facing, visual_facing);
visual_facing += diff * turn_speed;

// ------------------------------------------------------------
// HELPERS
// ------------------------------------------------------------
is_moving = (vlen > 0.1);

// ------------------------------------------------------------
// SMOKE TRAIL AT NEAR MAX SPEED
// ------------------------------------------------------------
var at_max = (vlen >= max_speed * 0.95);
if (at_max) {
    if (current_time div 60 != smoke_tick) {
        smoke_tick = current_time div 60;

        var back_dir = (facing + tip_angle_offset) + 180;
        var sx = x + lengthdir_x(10, back_dir) + random_range(-2, 2);
        var sy = y + lengthdir_y(10, back_dir) + random_range(-2, 2);

        instance_create_layer(sx, sy, layer, oSmokePuff);
    }
}

// ------------------------------------------------------------
// SKIDS
// ------------------------------------------------------------
skid_update(self, turn, vlen, !is_on_drivable());

// ------------------------------------------------------------
// CAMERA ZOOM BASED ON SPEED
// ------------------------------------------------------------
var speed_ratio = clamp(vlen / max_speed, 0, 1);
var target_zoom = lerp(cam_zoom_in, cam_zoom_out, speed_ratio);
cam_zoom_cur = lerp(cam_zoom_cur, target_zoom, cam_zoom_lerp);

var new_w = base_view_w * cam_zoom_cur;
var new_h = base_view_h * cam_zoom_cur;

camera_set_view_size(cam_id, new_w, new_h);
camera_set_view_pos(cam_id, x - new_w * 0.5, y - new_h * 0.5);

// ------------------------------------------------------------
// CHARGED SHOT (disabled while locked/spinning)
// Hold LMB or Shift to charge, release to fire
// Barely launches if released too quickly
// ------------------------------------------------------------
if (!locked) {

    var launch_down    = mouse_check_button(mb_left) || keyboard_check(vk_shift);
    var launch_press  = mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_shift);
    var launch_release= mouse_check_button_released(mb_left) || keyboard_check_released(vk_shift);

    // Start charging
    if (launch_press) {
        shoot_charging = true;
        shoot_charge = 0;
    }

    // Build charge while held
    if (shoot_charging && launch_down) {
        shoot_charge = min(shoot_charge + 1, shoot_charge_max);
    }

    // Release -> fire
    if (shoot_charging && launch_release) {
        shoot_charging = false;

        // Aim
        var fire_dir = point_direction(x, y, mouse_x, mouse_y);

        // --- Charge to speed mapping ---
        var bspd;

        if (shoot_charge < min_charge_frames) {
            // Barely launch
            bspd = barely_speed;
        } else {
            // Normalize charge AFTER threshold
            var q = (shoot_charge - min_charge_frames) / (shoot_charge_max - min_charge_frames);
            q = clamp(q, 0, 1);

            // Curve the ramp (late power)
            q = power(q, bullet_charge_pow);

            // Map to speed range
            bspd = lerp(bullet_speed_min, bullet_speed_max, q);
        }

        // Spawn at muzzle
        var muzzle_dist = 16;
        var bx = x + lengthdir_x(muzzle_dist, fire_dir);
        var by = y + lengthdir_y(muzzle_dist, fire_dir);

        var b = instance_create_layer(bx, by, layer, oBullet);

        // Bullet setup
        b.direction   = fire_dir;
        b.bullet_speed = bspd;
        b.inherit_hsp  = hsp;
        b.inherit_vsp  = vsp;

        // Reset charge
        shoot_charge = 0;
    }

} else {
    // Cancel charge if controls lock mid-hold
    shoot_charging = false;
    shoot_charge = 0;
}


