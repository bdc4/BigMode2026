x = mouse_x;
y = mouse_y;

image_blend = c_white;
if (place_meeting(x,y,oSelectable)) { image_blend = c_lime; }
	
draw_self();