var lines = array_length(options);
if (lines <= 0) exit;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var box_h = pad*2 + line_h*(lines + 1); // title + lines
var x1 = x_gui - w*0.5;
var y1 = y_gui + w*0.5;
var x2 = x1 + w;
var y2 = y1 + box_h;

// Background
draw_set_alpha(0.80);
draw_set_color(bg_col);
draw_rectangle(x1, y1, x2, y2, false);

// Border
draw_set_alpha(1);
draw_set_color(c_white);
draw_rectangle(x1, y1, x2, y2, true);

// Title
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(fg_col);
draw_text(x1 + pad, y1 + pad, title);

// Options
for (var i = 0; i < lines; i++) {
    var yy = y1 + pad + line_h*(i+1);

    if (i == selected) {
        draw_set_color(hl_col);
        draw_rectangle(x1 + 2, yy, x2 - 2, yy + line_h, false);
        draw_set_color(c_black);
        draw_text(x1 + pad, yy + 2, options[i]);
    } else {
        draw_set_color(fg_col);
        draw_text(x1 + pad, yy + 2, options[i]);
    }
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
