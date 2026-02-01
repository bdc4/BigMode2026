/// oPlayer : Step
/// Driving + effects + guaranteed no-overlap with solids

// ------------------------------------------------------------
// INPUT
// ------------------------------------------------------------
var throttle = keyboard_check(vk_space);

var turn = (keyboard_check(vk_left)  || keyboard_check(ord("A")))
         - (keyboard_check(vk_right) || keyboard_check(ord("D")));

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
// MOVE (sub-stepped) + BOUNCE BACK (NO FACING CHANGE)
// with HARD NO-OVERLAP GUARANTEE
// ------------------------------------------------------------
var crashed = false;

// last known good position
var safe_x = x;
var safe_y = y;

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

        // bounce X
        hsp = -hsp * bounce_loss;
        if (abs(hsp) < min_bounce_speed) hsp = 0;
        dx = hsp / steps;
    }

    // --- Y ---
    y += dy;
    hit = instance_place(x, y, all);
    if (hit != noone && hit.solid) {
        crashed = true;

        y -= dy;

        // bounce Y
        vsp = -vsp * bounce_loss;
        if (abs(vsp) < min_bounce_speed) vsp = 0;
        dy = vsp / steps;
    }

    // update safe position
    var check = instance_place(x, y, all);
    if (check == noone || !check.solid) {
        safe_x = x;
        safe_y = y;
    }
}

// Never end inside solids
var final_hit = instance_place(x, y, all);
if (final_hit != noone && final_hit.solid) {
    x = safe_x;
    y = safe_y;
    hsp = 0;
    vsp = 0;
    crashed = true;
}

// Optional: add a little "thud" slowdown on crash (feels good)
if (crashed) {
    hsp *= 0.85;
    vsp *= 0.85;
}

// Recompute vlen after movement changes
vlen = point_distance(0, 0, hsp, vsp);

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
skid_update(self, turn, vlen);

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
// FIRE BULLET
// ------------------------------------------------------------
if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_shift)) {

    var fire_dir = facing + tip_angle_offset;

    var muzzle_dist = 16;
    var bx = x + lengthdir_x(muzzle_dist, fire_dir);
    var by = y + lengthdir_y(muzzle_dist, fire_dir);

    var b = instance_create_layer(bx, by, layer, oBullet);
    b.direction = fire_dir;
}
