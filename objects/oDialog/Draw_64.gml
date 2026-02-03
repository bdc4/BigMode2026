/// oDialog : Draw GUI
if (!active) exit;

var gui_w = display_get_gui_width();
var gui_h = display_get_gui_height();

var box_x1 = pad;
var box_y2 = gui_h - pad;
var box_y1 = box_y2 - box_h;
var box_x2 = gui_w - pad;

// background
draw_set_alpha(0.85);
draw_set_color(c_black);
draw_rectangle(box_x1, box_y1, box_x2, box_y2, false);
draw_set_alpha(1);

// border
draw_set_color(c_white);
draw_rectangle(box_x1, box_y1, box_x2, box_y2, true);

// ---- PORTRAIT AREA ----
var has_portrait = (portrait_sprite != noone);
var portrait_x = box_x1 + portrait_pad;
var portrait_y = box_y1 + portrait_pad;

// Reserve space for portrait (even if missing, you can skip reserving by toggling this)
var text_x = box_x1 + 12;
if (has_portrait) {
    // portrait frame
    draw_set_color(c_white);
    draw_rectangle(
        portrait_x - 2, portrait_y - 2,
        portrait_x + portrait_size + 2, portrait_y + portrait_size + 2,
        true
    );

    // draw portrait sprite scaled into the square
    var sw = sprite_get_width(portrait_sprite);
    var sh = sprite_get_height(portrait_sprite);
    var sx = portrait_size / sw;
    var sy = portrait_size / sh;

    draw_sprite_ext(
        portrait_sprite, portrait_index,
        portrait_x, portrait_y,
        sx, sy,
        0,
        c_white,
        1
    );

    text_x = portrait_x + portrait_size + 16;
}

// speaker
draw_set_color(c_yellow);
draw_text(text_x, box_y1 + 10, speaker);

// current line
draw_set_color(c_white);
var cur = lines[line_index];
var shown = cur;
if (use_typewriter) shown = string_copy(cur, 1, shown_chars);

draw_text(text_x, box_y1 + 40, shown);
