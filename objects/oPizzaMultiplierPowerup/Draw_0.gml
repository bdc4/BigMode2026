if (global.progress < 8) exit;

event_inherited()
//draw_self();

draw_set_color(c_white);

image_alpha = oPlayer.money >= cost ? 1 : .5;


if (text != "") {
	draw_set_halign(fa_center)
	draw_set_color(c_black)
	draw_text(x, y+sprite_height, text);
	draw_set_halign(fa_left)
	draw_set_colour(c_white)
}