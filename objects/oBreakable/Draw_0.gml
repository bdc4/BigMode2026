event_inherited();

var newSprite = noone;

if (broken && sprite_index == type) {
	// check if sXxxBroken or sXxxBusted exists
	var name = sprite_get_name(sprite_index);
	var check = asset_get_index(string(name+"Busted"));
	if (!check) {
		var err = "no Broken or Busted sprite found for sprite: " + name;
			
		if (debug_mode) show_error(err, false)
		else show_debug_message(err);
	} else {
		// if (irandom(1) == 1) image_xscale = -1;
		newSprite = asset_get_index(check);
	}
}

if (newSprite && sprite_index != newSprite) {
	sprite_index = newSprite;
	if (object_index == oWindow) {
		image_index = irandom(sprite_get_number(sprite_index));
		image_speed = 0;
	}
}

draw_self();