/// oMenuZone : Draw GUI
// Hint appears above player when they're in this zone and stopped long enough.

var p = instance_place(x, y, oPlayer);
if (p == noone) exit;

// Speed check (uses hsp/vsp like your driving code)
var spd = point_distance(0, 0, p.hsp, p.vsp);
if (spd > stop_speed) exit;

// Must be parked long enough
if (_stop_timer < stop_frames) exit;

// --- Convert player world position -> GUI position ---
var cam = view_camera[0];
var vx  = camera_get_view_x(cam);
var vy  = camera_get_view_y(cam);
var vw  = camera_get_view_width(cam);
var vh  = camera_get_view_height(cam);

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// Player world -> normalized view -> GUI
var px = (p.x - vx) / vw * gw;
var py = (p.y - vy) / vh * gh;

// Offset above player
py += 60;

// --- Draw hint ---
var msg = instance_exists(oPopupMenu) ? "W/S = Up/Down\nCtrl = Select" : "Press CTRL";

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// shadow
draw_set_color(c_black);
draw_set_alpha(0.7);
draw_text(px + 1, py + 1, msg);

// text
draw_set_color(c_white);
draw_set_alpha(1);
draw_text(px, py, msg);

// reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
