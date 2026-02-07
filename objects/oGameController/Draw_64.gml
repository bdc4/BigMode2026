/// oGameController : Draw GUI

var pad      = 16;
var box_pad  = 10;
var line_gap = 4;

// Text
var header_text = "OBJECTIVE: ("  + string(global.progress+1) + " / 10)";
global.current_objective = global.objectives[global.progress];
var body_text   = global.current_objective;

// Measure text
draw_set_font(-1); // your UI font
var header_w = string_width(header_text);
var header_h = string_height(header_text);

var body_w = string_width(body_text);
var body_h = string_height(body_text);

// Box size = max width of header/body + padding
var box_w = max(header_w, body_w) + box_pad * 2;
var box_h = header_h + line_gap + body_h + box_pad * 2;

// Top-right position
var gui_w = display_get_gui_width();
var xR = gui_w - pad;
var yT = pad;

// --------------------------------------------------
// Background box
// --------------------------------------------------
draw_set_alpha(0.75);
draw_set_color(c_black);

draw_rectangle(
    xR - box_w,
    yT,
    xR,
    yT + box_h,
    false
);

draw_set_alpha(1);

// --------------------------------------------------
// Text
// --------------------------------------------------
draw_set_halign(fa_right);
draw_set_valign(fa_top);

// Header
draw_set_color(c_yellow);
draw_text(
    xR - box_pad,
    yT + box_pad,
    header_text
);

// Body
draw_set_color(c_white);
draw_text(
    xR - box_pad,
    yT + box_pad + header_h + line_gap,
    body_text
);

// Reset
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
