event_inherited();
draw_self();

if (wantsPizza)
{
	var spr = sPizzaTimer;
	var sub = 0;
	
    var px = x + sprite_width*.5 - sprite_get_width(spr)/2
    var py = y + sprite_height/3;

    ratio = clamp(alarm[0] / pizza_timer_max, 0, 1);
    if (ratio <= 0) exit;
    

	var w_local = sprite_get_width(spr);
	var h_local = sprite_get_height(spr);
	
	draw_sprite_part(spr, 0, 0, 0, w_local, (h_local * ratio), px, py)


}
