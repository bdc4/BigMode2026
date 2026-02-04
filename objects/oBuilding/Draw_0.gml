image_blend = c_white;
if (is_target) {
	image_blend = c_red;
	draw_set_color(image_blend);
draw_rectangle(x,y,x+bbox_right,y+bbox_bottom,false)
}


// draw_self();

draw_set_color(c_black);
draw_text(x, y, string(id));