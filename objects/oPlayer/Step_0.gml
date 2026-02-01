/// oPlayer : Step
/// Space accelerates forward (toward sprite tip), Left/Right turn

// --- Input ---
var throttle = keyboard_check(vk_space);
var turn = (keyboard_check(vk_left)  || keyboard_check(ord("A")))
         - (keyboard_check(vk_right) || keyboard_check(ord("D")))

// --- Turning ---
if (turn != 0) {
    // Optional: scale turning down a bit at low speed so it doesn't spin in place
    var spd = point_distance(0, 0, hsp, vsp);
    var turn_scale = clamp(spd / max_speed, 0.25, 1.0);
    facing += turn * turn_rate * turn_scale;
}
facing = (facing mod 360 + 360) mod 360;

// --- Thrust (accelerate toward the "tip") ---
if (throttle) {
    var thrust_dir = facing + tip_angle_offset;
    hsp += lengthdir_x(engine_accel, thrust_dir);
    vsp += lengthdir_y(engine_accel, thrust_dir);
}

// --- Drag / friction (always on) ---
var drag_target = drag_base + random_range(-drag_jitter, drag_jitter);
drag_cur = lerp(drag_cur, drag_target, drag_smooth);

hsp *= (1 - drag_cur);
vsp *= (1 - drag_cur);


// --- Clamp max speed (magnitude) ---
var vlen = point_distance(0, 0, hsp, vsp);
if (vlen > max_speed) {
    var s = max_speed / vlen;
    hsp *= s;
    vsp *= s;
}

// --- Move ---
x += hsp;
y += vsp;

// --- Smooth sprite rotation toward facing 
var diff = angle_difference(facing, visual_facing);
visual_facing += diff * turn_speed;

// --- Helper ---
is_moving = (vlen > 0.1);

// --- Smoke trail at (near) max speed ---

var at_max = (vlen >= max_speed * 0.95);

if (at_max) {
    // spawn every N steps (tune)
    if (current_time div 60 != smoke_tick) { // ~1 puff per 60ms
        smoke_tick = current_time div 60;

        // position behind the car
        var back_dir = (facing + tip_angle_offset) + 180;
        var bx = x + lengthdir_x(10, back_dir) + random_range(-2, 2);
        var by = y + lengthdir_y(10, back_dir) + random_range(-2, 2);

        instance_create_layer(bx, by, layer, oSmokePuff);
    }
}

skid_update(self, turn, vlen);

// --- Speed-based camera zoom ---
var speed_ratio = clamp(vlen / max_speed, 0, 1);

// Lerp zoom between in and out based on speed
var target_zoom = lerp(cam_zoom_in, cam_zoom_out, speed_ratio);

// Smooth camera zoom
cam_zoom_cur = lerp(cam_zoom_cur, target_zoom, cam_zoom_lerp);

var new_w = base_view_w * cam_zoom_cur;
var new_h = base_view_h * cam_zoom_cur;

// Keep camera centered on player
camera_set_view_size(cam_id, new_w, new_h);
camera_set_view_pos(
    cam_id,
    x - new_w * 0.5,
    y - new_h * 0.5
);

