/// oAchievement : Draw GUI
var gw = display_get_gui_width();
var gh = display_get_gui_height();
var xR = gw - ui_pad;
var yT = gh - ui_h - ui_v_pad;

if (oPlayer.demo_mode) exit;

if (playerHover) {
	if (keyboard_check(vk_shift)) {
		draw_set_colour(c_black)
		draw_rectangle(0,0,gw,gh,false);
		draw_set_colour(c_white)
		draw_set_font(fntMain)
		draw_set_halign(fa_left)
		
		// for each achievement, draw here
		var _keys = ["bib","cook","bell","bby","rts"]
		offset = 0;
		array_foreach(_keys, function(_key) {
			var a = ds_map_find_value(ach, _key);
			
			var _title = a.title;
			var _desc = a.desc;
			var _unlocked = a.unlocked;
			var _color = _unlocked ? c_lime : c_red;
			
			var __text = string(a.title) + "\n" + string(_unlocked ? string(a.desc) : "???");
			
			draw_text_colour(120, 120 + offset, __text,_color,_color,_color,_color,1)
			offset += 120;
		})
	}
}

if (popup == noone || oPlayer.demo_mode) exit;

// slide + fade
var a = 1;
var slide = 0;

if (popup_t < popup_in) {
    var t = popup_t / popup_in;
    a = t;
    slide = (1 - t) * 24;
}
else if (popup_t > popup_in + popup_hold) {
    var t2 = (popup_t - (popup_in + popup_hold)) / popup_out;
    a = 1 - t2;
    slide = t2 * 24;
}

var x0 = xR - ui_w;
var y0 = yT + slide;

// background
draw_set_alpha(0.75 * a);
draw_set_color(c_black);
draw_rectangle(x0, y0, x0 + ui_w, y0 + ui_h, false);

// border
draw_set_alpha(1 * a);
draw_set_color(c_white);
draw_rectangle(x0, y0, x0 + ui_w, y0 + ui_h, true);

// icon
var icon = popup.spr;
var icon_x = x0 + 12;
var icon_y = y0 + ui_h * 0.5;

draw_set_alpha(1 * a);
draw_set_color(c_white);
if (icon != -1) {
    draw_sprite_ext(icon, 0, icon_x, icon_y, 1, 1, 0, c_white, a);
}

// text
var tx = x0 + 12 + 48;
var title_y = y0 + 18;
var desc_y  = y0 + 46;

draw_set_alpha(1 * a);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(-1);
draw_set_color(c_yellow);
draw_text(tx, title_y, popup.title);

draw_set_color(c_white);
draw_text(tx, desc_y, popup.desc);

// reset
draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);