/// oAchievement : Draw GUI
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var xR = gw - ui_pad;
var yT = gh - ui_h - ui_v_pad;

if (oPlayer.demo_mode) exit;

if (playerHover) {
	
	draw_set_color(c_black);
	draw_set_halign(fa_center)
	draw_text(x,y,"Hold SHIFT to view Achievements!")
	
}


// reset
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);