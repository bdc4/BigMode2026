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
// DEMO AUTOPILOT (disables steering/throttle, follows a path)
// ------------------------------------------------------------
if (demo_mode) {
	
	if (keyboard_check_pressed(vk_space)) {
		demo_mode = false;
		exit;
	}

    // Advance along path by distance
    var plen = max(1, path_get_length(demo_path));
    demo_pos += demo_speed / plen;
    if (demo_pos >= 1) demo_pos -= 1; // loop

    // Sample path at current pos and lookahead pos (0..1)
    var x0 = path_get_x(demo_path, demo_pos);
    var y0 = path_get_y(demo_path, demo_pos);

    var p2 = demo_pos + demo_look;
    if (p2 >= 1) p2 -= 1;

    var xt = path_get_x(demo_path, p2);
    var yt = path_get_y(demo_path, p2);

    // Desired heading from path tangent (NOT from player position)
    var desired = point_direction(x0, y0, xt, yt);

    // Steer toward desired
    var diff = angle_difference(desired, facing);
    facing += clamp(diff, -demo_turn_rate, demo_turn_rate);
    facing = (facing mod 360 + 360) mod 360;

    // Thrust forward
    var thrust_dir = facing + tip_angle_offset;
    hsp += lengthdir_x(demo_throttle, thrust_dir);
    vsp += lengthdir_y(demo_throttle, thrust_dir);

    // Drag
    hsp *= (1 - demo_drag);
    vsp *= (1 - demo_drag);

    // Clamp speed
    var vlen = point_distance(0, 0, hsp, vsp);
    if (vlen > demo_speed) {
        var s = demo_speed / vlen;
        hsp *= s; vsp *= s;
    }

    // Move
    x += hsp;
    y += vsp;

    // Stronger “magnet” to path if we drift (prevents corner overshoot)
    var dpath = point_distance(x, y, x0, y0);
    var snap = lerp(demo_snap, 0.35, clamp(dpath / 32, 0, 1)); // more snap when far
    x = lerp(x, x0, snap);
    y = lerp(y, y0, snap);

    // Smooth sprite rotation
    var d = angle_difference(facing, visual_facing);
    visual_facing += d * turn_speed;
    is_moving = true;
	
	skid_update(self, [1,0,0,0][irandom(3)], max_speed, !is_on_drivable());

    exit; // skip normal controls/physics below
}




// ------------------------------------------------------------
// INPUT (disabled during crash lock / spin-out)
// ------------------------------------------------------------
if (instance_exists(oPopupMenu)) exit;

var spinning = (spin_time > 0);
locked = (crash_timer > 0) || spinning;

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
// Robust: checks only solids and never "misses" due to all/non-solid returns
// ------------------------------------------------------------
var crashed = false;
var impact_vlen = vlen;

var step_size = 1;
var steps = ceil(max(abs(hsp), abs(vsp)) / step_size);
if (steps < 1) steps = 1;

var dx = hsp / steps;
var dy = vsp / steps;

for (var i = 0; i < steps; i++)
{
    // --- X ---
    if (dx != 0) {
        x += dx;

        var hit = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, oWall, false, true);
        // ^ last arg "true" = solidOnly, so hit is guaranteed solid if not noone
        if (hit != noone) {
            crashed = true;
            x -= dx;

            var impact_speed = point_distance(0, 0, hsp, vsp);
            bounce_launch_away(hit, impact_speed);

            // recompute remaining per-step motion after bounce
            dx = hsp / steps;
            dy = vsp / steps;
        }
    }

    // --- Y ---
    if (dy != 0) {
        y += dy;

        var hit2 = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, oWall, false, true);
        if (hit2 != noone) {
            crashed = true;
            y -= dy;

            var impact_speed2 = point_distance(0, 0, hsp, vsp);
            bounce_launch_away(hit2, impact_speed2);

            dx = hsp / steps;
            dy = vsp / steps;
        }
    }
}

// Final safety: never end inside solids
var final_hit = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, oWall, false, true);
if (final_hit != noone) {
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
// CHARGED TARGET SHOT (disabled while locked/spinning)
// Hold LMB or Shift to charge, release to fire
// Bullet launches at the *nearest oBreakable to the cursor* and lands on its sprite center
// ------------------------------------------------------------
if (!locked) {

    var launch_down     = mouse_check_button(mb_left)
    var launch_press    = mouse_check_button_pressed(mb_left)
    var launch_release  = mouse_check_button_released(mb_left)

    // Start charging
    if (launch_press) {
        shoot_charging = true;
        shoot_charge = 0;
    }

    // Build charge while held
    if (shoot_charging && launch_down) {
        shoot_charge = min(shoot_charge + 1, shoot_charge_max);
    }

    // Release -> acquire target -> fire
    if (shoot_charging && launch_release) {
        shoot_charging = false;

        var mx = mouse_x;
        var my = mouse_y;

        target = noone;//instance_nearest(mx, my, oBreakable);
        with (oSelectable) {
			if (selected) {
				other.target = id;
			}
		}
		if (target != noone && ammo > 0) {
			
			ammo--;

            // --- Target the exact sprite center in room coordinates ---
            // Uses sprite + image_xscale/yscale + origin to compute center.
            var spr = target.sprite_index;
            var tx, ty;

            if (spr != -1) {
                // sprite center offset from origin (local)
                var cx_local = (sprite_get_width(spr)  * 0.5) - sprite_get_xoffset(spr);
                var cy_local = (sprite_get_height(spr) * 0.75) - sprite_get_yoffset(spr);

                // apply scaling (no rotation handling here; most breakables won't rotate)
                tx = target.x + cx_local * target.image_xscale;
                ty = target.y + cy_local * target.image_yscale;
            } else {
                // fallback
                tx = (target.bbox_left + target.bbox_right) * 0.5;
                ty = (target.bbox_top  + target.bbox_bottom) * 0.5;
            }

           // Aim from player to target center (tx, ty already computed)
			var fire_dir = point_direction(x, y, tx, ty);

			// Spawn at muzzle
			var muzzle_dist = 16;
			var bx = x + lengthdir_x(muzzle_dist, fire_dir);
			var by = y + lengthdir_y(muzzle_dist, fire_dir);

			// Bullet speed always max
			var bspd = bullet_speed_max;

			// Compute flight time so it lands exactly on the center
			var dist = point_distance(bx, by, tx, ty);
			var ft = max(1, ceil(dist / bspd));

			var b = instance_create_layer(bx, by, "GUI", oBullet);

			// Tell bullet exactly where to land
			b.target_id   = target;
			b.dest_x      = tx;
			b.dest_y      = ty;
			b.flight_time = ft;
			b.t           = 0;

			// Optional (visuals)
			b.direction    = fire_dir;
			b.bullet_speed = bspd;


            // (Optional) pass momentum for VFX only — don't apply to position if you need exact landing
            // b.inherit_hsp = hsp;
            // b.inherit_vsp = vsp;
        }

        shoot_charge = 0;
    }

} else {
    shoot_charging = false;
    shoot_charge = 0;
}
