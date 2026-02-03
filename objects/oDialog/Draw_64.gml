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

// speaker
draw_set_color(c_yellow);
draw_text(box_x1 + 12, box_y1 + 10, speaker);

// current line
draw_set_color(c_white);
var cur = lines[line_index];
var shown = cur;
if (use_typewriter) shown = string_copy(cur, 1, shown_chars);

draw_text(box_x1 + 12, box_y1 + 40, shown);

// "continue" hint
// draw_set_color(c_gray);
// draw_text(box_x2 - 80, box_y2 - 24, "[Space]");
