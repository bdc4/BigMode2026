/// oPlayer : Draw GUI

// ------------------------------------------------------------
// AMMO TRACKER (icon + text) — TOP LEFT
// ------------------------------------------------------------

// Data
var ammo_cur = ammo;
var ammo_max = variable_instance_exists(self, "max_ammo") ? max_ammo : -1;

// Layout constants
var pad     = 32;
var icon_sz = 24;
var gap     = 8;
var vgap    = 8; // space between ammo + money panels

// Position (top-left)
var x0 = pad;
var y0 = pad;

// Text string
var ammo_txt = (ammo_max >= 0)
    ? string(ammo_cur) + "/" + string(ammo_max)
    : string(ammo_cur);

// Measure text
draw_set_font(-1);
var tw = string_width(ammo_txt);
var th = string_height(ammo_txt);

// Background size
var bg_w = pad + icon_sz + gap + tw + pad;
var bg_h = max(icon_sz, th) + pad * 2;

// --- Background ---
draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(x0, y0, x0 + bg_w, y0 + bg_h, false);

// --- Icon ---
draw_set_alpha(1);
draw_set_color(c_white);
draw_sprite_ext(
    sPizza, 0,
    x0 + pad,
    y0 + bg_h * 0.5,
    .5, .5,
    0,
    c_white,
    1
);

// --- Text ---
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(
    x0 + pad + icon_sz + gap,
    y0 + bg_h * 0.5,
    ammo_txt
);

// ------------------------------------------------------------
// MONEY (icon + text) — BELOW AMMO
// ------------------------------------------------------------

// Data (change this to your actual variable if different)
var money_val = variable_instance_exists(self, "money") ? money : (variable_global_exists("money") ? global.money : 0);
var money_txt = "$" + string(money_val);

// Measure money text
var mtw = string_width(money_txt);
var mth = string_height(money_txt);

// Money panel size (match ammo width for a clean stack)
var m_bg_w = max(bg_w, pad + icon_sz + gap + mtw + pad);
var m_bg_h = max(icon_sz, mth) + pad * 2;

// Money panel position
var mx0 = x0;
var my0 = y0 + bg_h + vgap;

// --- Background ---
draw_set_alpha(0.6);
draw_set_color(c_black);
draw_rectangle(mx0, my0, mx0 + m_bg_w, my0 + m_bg_h, false);

// --- Icon (swap this sprite if you have a coin sprite) ---
draw_set_alpha(1);
draw_set_color(c_white);
draw_sprite_ext(
    sSchoolFlag, 0, 
    mx0 + pad,
    my0 + m_bg_h * 0.5,
    0.125, 0.125,
    0,
    c_white,
    1
);

// --- Text ---
draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_text(
    mx0 + pad + icon_sz + gap,
    my0 + m_bg_h * 0.5,
    money_txt
);

// Reset draw state
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);



// ------------------------------------------------------------
// (your existing off-screen arrow code continues below...)
// ------------------------------------------------------------
if (!variable_global_exists("target_building") || !instance_exists(global.target_building)) exit;

// ... rest of your arrow code ...




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




