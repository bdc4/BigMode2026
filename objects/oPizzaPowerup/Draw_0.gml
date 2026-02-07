// Inherit the parent event

if (oPlayer.max_ammo <= 0) exit;

if (oPlayer.ammo >= oPlayer.max_ammo) {
	image_alpha = .5;
} else {
	image_alpha = 1;
}

event_inherited();