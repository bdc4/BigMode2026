image_blend = c_white;
if (is_target) {
	image_blend = c_red;
}

draw_self();

draw_set_color(c_black);
draw_text(x, y, string(id));