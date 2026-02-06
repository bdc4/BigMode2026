/// oPlayer : Step
/// Driving + effects + hard no-overlap + crash lock + high-speed spin-out
/// Includes demo autopilot + 8-dir fake diagonals (±45°) + target-shot

// ============================================================
// Helpers
// ============================================================
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

    var out_speed = max(_impact_speed, min_bounce_speed) * bounce_loss;
    hsp = nx * out_speed;
    vsp = ny * out_speed;
}

function is_on_drivable()
{
    var cx = (bbox_left + bbox_right) * 0.5;
    var cy = (bbox_top  + bbox_bottom) * 0.5;

    if (tilemap_get_at_pixel(road_map_id, cx, cy) != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_left,  bbox_top)    != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_right, bbox_top)    != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_left,  bbox_bottom) != 0) return true;
    if (tilemap_get_at_pixel(road_map_id, bbox_right, bbox_bottom) != 0) return true;

    return false;
}

// 8-direction sprite pick with "fake" diagonals via ±45° rotation
// NOTE: If NE/SE feel swapped, flip the signs on the ±45 cases.
function pick_sprite_8dir_fake(_ang)
{
    var a  = (_ang mod 360 + 360) mod 360;
    var d8 = (floor((a + 22.5) / 45)) mod 8; // 0=E,1=NE,2=N,3=NW,4=W,5=SW,6=S,7=SE

    image_angle = 0; // reset every step

    switch (d8) {
        case 0: sprite_index = spr_right; image_angle = 0;    break; // E
        case 1: sprite_index = spr_up; image_angle = -45;  break; // NE
        case 2: sprite_index = spr_up;    image_angle = 0;    break; // N
        case 3: sprite_index = spr_up;  image_angle = 45;   break; // NW
        case 4: sprite_index = spr_left;  image_angle = 0;    break; // W
        case 5: sprite_index = spr_down;  image_angle = -45;  break; // SW
        case 6: sprite_index = spr_down;  image_angle = 0;    break; // S
        case 7: sprite_index = spr_down; image_angle = 45;   break; // SE
    }
}

// ============================================================
// Early exit: menu open
// ============================================================
if (instance_exists(oPopupMenu)) exit;

// Cache offroad once per step
var offroad = !is_on_drivable();

// ============================================================
// DEMO AUTOPILOT (follows a path, disables controls)
// ============================================================
if (demo_mode)
{
    // press space to take control immediately
    if (keyboard_check_pressed(vk_space)) {
        demo_mode = false;
        // fall through into normal logic this same frame
    } else {

        var plen = max(1, path_get_length(demo_path));
        demo_pos += demo_speed / plen;
        if (demo_pos >= 1) demo_pos -= 1;

        var x0 = path_get_x(demo_path, demo_pos);
        var y0 = path_get_y(demo_path, demo_pos);

        var p2 = demo_pos + demo_look;
        if (p2 >= 1) p2 -= 1;

        var xt = path_get_x(demo_path, p2);
        var yt = path_get_y(demo_path, p2);

        var desired = point_direction(x0, y0, xt, yt);

        var diff_demo = angle_difference(desired, facing);
        facing += clamp(diff_demo, -demo_turn_rate, demo_turn_rate);
        facing = (facing mod 360 + 360) mod 360;

        var thrust_dir_demo = facing + tip_angle_offset;
        hsp += lengthdir_x(demo_throttle, thrust_dir_demo);
        vsp += lengthdir_y(demo_throttle, thrust_dir_demo);

        hsp *= (1 - demo_drag);
        vsp *= (1 - demo_drag);

        var vlen_demo = point_distance(0, 0, hsp, vsp);
        if (vlen_demo > demo_speed) {
            var s_demo = demo_speed / vlen_demo;
            hsp *= s_demo; vsp *= s_demo;
            vlen_demo = demo_speed;
        }

        x += hsp;
        y += vsp;

        var dpath = point_distance(x, y, x0, y0);
        var snap = lerp(demo_snap, 0.35, clamp(dpath / 32, 0, 1));
        x = lerp(x, x0, snap);
        y = lerp(y, y0, snap);

        var dvis_demo = angle_difference(facing, visual_facing);
        visual_facing += dvis_demo * turn_speed;

        is_moving = true;

        var demo_turn = choose(-1, 0, 1);
        skid_update(self, demo_turn, vlen_demo, offroad);

        // 8-dir pick + diagonals
        pick_sprite_8dir_fake(visual_facing);

        exit;
    }
}

// ============================================================
// INPUT (disabled during crash lock / spin-out)
// ============================================================
var spinning = (spin_time > 0);
locked = (crash_timer > 0) || spinning;

var throttle = (!locked) && keyboard_check(vk_space);

var turn = 0;
if (!locked) {
    turn = (keyboard_check(vk_left)  || keyboard_check(ord("A")))
         - (keyboard_check(vk_right) || keyboard_check(ord("D")));
}

if (crash_timer > 0) crash_timer -= 1;

// ============================================================
// TURNING
// ============================================================
if (turn != 0) {
    var spd = point_distance(0, 0, hsp, vsp);
    var turn_scale = clamp(spd / max_speed, 0.25, 1.0);
    facing += turn * turn_rate * turn_scale;
}
facing = (facing mod 360 + 360) mod 360;

// ============================================================
// THRUST
// ============================================================
if (throttle) {
    var thrust_dir = facing + tip_angle_offset;
    hsp += lengthdir_x(engine_accel, thrust_dir);
    vsp += lengthdir_y(engine_accel, thrust_dir);
}

// ============================================================
// DRAG
// ============================================================
var drag_target = drag_base + random_range(-drag_jitter, drag_jitter);
drag_cur = lerp(drag_cur, drag_target, drag_smooth);

hsp *= (1 - drag_cur);
vsp *= (1 - drag_cur);

// Offroad extra drag
if (offroad) {
    hsp *= (1 - road_drag_extra);
    vsp *= (1 - road_drag_extra);
}

// ============================================================
// CLAMP SPEED
// ============================================================
var vlen = point_distance(0, 0, hsp, vsp);
if (vlen > max_speed) {
    var s = max_speed / vlen;
    hsp *= s;
    vsp *= s;
    vlen = max_speed;
}

// ============================================================
// MOVE (sub-stepped) + bounce off SOLID walls (oWall)
// ============================================================
var crashed = false;
var impact_vlen = vlen;

var step_size = 1;
var steps = ceil(max(abs(hsp), abs(vsp)) / step_size);
if (steps < 1) steps = 1;

var dx = hsp / steps;
var dy = vsp / steps;

for (var i = 0; i < steps; i++)
{
    if (dx != 0) {
        x += dx;

        var hit = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, oWall, false, true);
        if (hit != noone) {
            crashed = true;
            x -= dx;

            var impact_speed = point_distance(0, 0, hsp, vsp);
            bounce_launch_away(hit, impact_speed);

            dx = hsp / steps;
            dy = vsp / steps;
        }
    }

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

var final_hit = collision_rectangle(bbox_left, bbox_top, bbox_right, bbox_bottom, oWall, false, true);
if (final_hit != noone) {
    crashed = true;
    var impact_speed3 = max(impact_vlen, min_bounce_speed);
    bounce_launch_away(final_hit, impact_speed3);
}

// ============================================================
// CRASH EFFECTS
// ============================================================
if (crashed)
{
    if (crash_timer <= 0) crash_timer = crash_lock_frames;

    var r = clamp(impact_vlen / max_speed, 0, 1);
    facing = (facing + 180 * r) mod 360;

    var spin_threshold = 0.75;
    if (r >= spin_threshold && spin_time <= 0) {
        var t = clamp((r - spin_threshold) / (1 - spin_threshold), 0, 1);
        spin_time = spin_time_max;
        spin_dir = choose(-1, 1);
        spin_start_rate = lerp(18, 60, t);
    }

    hsp *= 0.85;
    vsp *= 0.85;
}

// Recompute after collisions
vlen = point_distance(0, 0, hsp, vsp);

// ============================================================
// SPIN-OUT UPDATE
// ============================================================
if (spin_time > 0) {
    var u = spin_time / spin_time_max;
    var rate = spin_start_rate * u;
    facing = (facing + spin_dir * rate) mod 360;

    spin_time -= 1;
    if (spin_time <= 0) {
        spin_time = 0;
        spin_start_rate = 0;
    }
}

// ============================================================
// SMOOTH VISUAL FACING + SPRITE PICK (8-dir + diagonals)
// ============================================================
var diff = angle_difference(facing, visual_facing);
visual_facing += diff * turn_speed;

pick_sprite_8dir_fake(visual_facing);

// ============================================================
// HELPERS / EFFECTS
// ============================================================
is_moving = (vlen > 0.1);

// Smoke trail near max speed
if (vlen >= max_speed * 0.95) {
    if (current_time div 60 != smoke_tick) {
        smoke_tick = current_time div 60;

        var back_dir = (facing + tip_angle_offset) + 180;
        var sx = x + lengthdir_x(10, back_dir) + random_range(-2, 2);
        var sy = y + lengthdir_y(10, back_dir) + random_range(-2, 2);

        instance_create_layer(sx, sy, layer, oSmokePuff);
    }
}

// Skids
skid_update(self, turn, vlen, offroad);

// Camera zoom based on speed
var speed_ratio = clamp(vlen / max_speed, 0, 1);
var target_zoom = lerp(cam_zoom_in, cam_zoom_out, speed_ratio);
cam_zoom_cur = lerp(cam_zoom_cur, target_zoom, cam_zoom_lerp);

var new_w = base_view_w * cam_zoom_cur;
var new_h = base_view_h * cam_zoom_cur;

camera_set_view_size(cam_id, new_w, new_h);
camera_set_view_pos(cam_id, x - new_w * 0.5, y - new_h * 0.5);

// ============================================================
// TARGET SHOT (disabled while locked/spinning)
// ============================================================
if (!locked)
{
    var launch_down    = mouse_check_button(mb_left);
    var launch_press   = mouse_check_button_pressed(mb_left);
    var launch_release = mouse_check_button_released(mb_left);

    if (launch_press) { shoot_charging = true; shoot_charge = 0; }
    if (shoot_charging && launch_down) shoot_charge = min(shoot_charge + 1, shoot_charge_max);

    if (shoot_charging && launch_release) {
        shoot_charging = false;

        target = noone;
        with (oSelectable) if (selected) other.target = id;

        if (target != noone && ammo > 0) {
            ammo--;

            var spr = target.sprite_index;
            var tx, ty;

            if (spr != -1) {
                var cx_local = (sprite_get_width(spr)  * 0.5) - sprite_get_xoffset(spr);
                var cy_local = (sprite_get_height(spr) * 0.5) - sprite_get_yoffset(spr);
                tx = target.x + cx_local * target.image_xscale;
                ty = target.y + cy_local * target.image_yscale;
            } else {
                tx = (target.bbox_left + target.bbox_right) * 0.5;
                ty = (target.bbox_top  + target.bbox_bottom) * 0.5;
            }

            var fire_dir = point_direction(x, y, tx, ty);

            var muzzle_dist = 16;
            var bx = x + lengthdir_x(muzzle_dist, fire_dir);
            var by = y + lengthdir_y(muzzle_dist, fire_dir);

            var bspd = bullet_speed_max;
            var dist = point_distance(bx, by, tx, ty);
            var ft = max(1, ceil(dist / bspd));

            var b = instance_create_layer(bx, by, layer, oBullet);
            b.target_id   = target;
            b.dest_x      = tx;
            b.dest_y      = ty;
            b.flight_time = ft;
            b.t           = 0;
            b.direction    = fire_dir;
            b.bullet_speed = bspd;
        }

        shoot_charge = 0;
    }
}
else {
    shoot_charging = false;
    shoot_charge = 0;
}
