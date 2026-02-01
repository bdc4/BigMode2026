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
/// --- Corner-safe move + bounce (sub-stepped) ---
var step_size = 1; // 1 px is safest; 2–4 is faster but less accurate

// How many substeps needed for this frame?
var steps = ceil(max(abs(hsp), abs(vsp)) / step_size);
if (steps < 1) steps = 1;

var dx = hsp / steps;
var dy = vsp / steps;

for (var i = 0; i < steps; i++)
{
    // Move X
    x += dx;
    var hit = instance_place(x, y, all);
    if (hit != noone && hit.solid) {
        x -= dx;

        // bounce X and recompute remaining dx
        hsp = -hsp * bounce_loss;
        if (abs(hsp) < min_bounce_speed) hsp = 0;

        dx = hsp / steps;
    }

    // Move Y
    y += dy;
    hit = instance_place(x, y, all);
    if (hit != noone && hit.solid) {
        y -= dy;

        // bounce Y and recompute remaining dy
        vsp = -vsp * bounce_loss;
        if (abs(vsp) < min_bounce_speed) vsp = 0;

        dy = vsp / steps;
    }
}

// Emergency unstick (rare but good)
var hit = instance_place(x, y, all);
var tries = 0;
while (hit != noone && hit.solid && tries < 16) {
    // push out opposite current movement
    x -= sign(hsp);
    y -= sign(vsp);
    hit = instance_place(x, y, all);
    tries++;
}


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

// Fire (example: Left Mouse or Shift)
if (mouse_check_button_pressed(mb_left) || keyboard_check_pressed(vk_shift)) {

    var fire_dir = facing + tip_angle_offset;

    // Spawn from the "tip" of the car
    var muzzle_dist = 16;
    var bx = x + lengthdir_x(muzzle_dist, fire_dir);
    var by = y + lengthdir_y(muzzle_dist, fire_dir);

    var b = instance_create_layer(bx, by, layer, oBullet);
    b.direction = fire_dir;
}
