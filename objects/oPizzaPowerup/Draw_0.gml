// Inherit the parent event

if (oPlayer.ammo >= oPlayer.max_ammo) {
	image_alpha = .5;
} else {
	image_alpha = 1;
}

event_inherited();