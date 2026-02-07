event_inherited();

// image_blend = c_white;
if (is_target) {
	image_blend = c_red;
	draw_set_color(image_blend);
	draw_rectangle(x,y,x+32,y+32,false)
}


draw_self();

if (debug_mode) {
draw_set_color(c_black);
draw_text(x, y, string(id));
}