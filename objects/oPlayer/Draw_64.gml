/// oPlayer : Draw GUI
if (!variable_global_exists("target_building") || !instance_exists(global.target_building)) exit;

// --- Camera view in world space ---
var cam = view_camera[0];
var vx = camera_get_view_x(cam);
var vy = camera_get_view_y(cam);
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);

// --- Target position (world) ---
var tx = global.target_building.x;
var ty = global.target_building.y;

// --- Is target on-screen? ---
var onscreen =
    (tx >= vx) && (tx <= vx + vw) &&
    (ty >= vy) && (ty <= vy + vh);

if (onscreen) exit;

// --- GUI size ---
var gw = display_get_gui_width();
var gh = display_get_gui_height();

// --- Direction from camera center to target (world direction) ---
var cx = vx + vw * 0.5;
var cy = vy + vh * 0.5;
var dir = point_direction(cx, cy, tx, ty);

// Unit direction vector (in screen space we can reuse these)
var dx = lengthdir_x(1, dir);
var dy = lengthdir_y(1, dir);

// --- Find point on screen edge in that direction ---
var margin = 24; // distance from screen edge
var hw = gw * 0.5 - margin;
var hh = gh * 0.5 - margin;

// --- Distance-based width ---
var dist = point_distance(cx, cy, tx, ty);

// Tuning
var close_dist = 128;   // distance where arrow is max wide
var far_dist   = 2000;  // distance where arrow is narrow

// 0..1 where 1 = very close, 0 = very far
var t = clamp((far_dist - dist) / (far_dist - close_dist), 0, 1);

// Spread angle in degrees
var spread = lerp(140, 40, t); // narrow -> wide

// Scale so it hits the rectangle boundary
var sx = (abs(dx) < 0.0001) ? 1000000 : (hw / abs(dx));
var sy = (abs(dy) < 0.0001) ? 1000000 : (hh / abs(dy));
var s = min(sx, sy);

// Arrow position on GUI
var ax = gw * 0.5 + dx * s;
var ay = gh * 0.5 + dy * s;

// --- Draw arrow (triangle with variable width) ---
var size = 18;
var tip_x = ax + lengthdir_x(size, dir);
var tip_y = ay + lengthdir_y(size, dir);

// Use spread instead of fixed 140
var left_x = ax + lengthdir_x(size * 0.7, dir + spread);
var left_y = ay + lengthdir_y(size * 0.7, dir + spread);

var right_x = ax + lengthdir_x(size * 0.7, dir - spread);
var right_y = ay + lengthdir_y(size * 0.7, dir - spread);

draw_set_alpha(0.5);
draw_set_color(c_red);
draw_triangle(tip_x, tip_y, left_x, left_y, right_x, right_y, false);
draw_set_alpha(1);
