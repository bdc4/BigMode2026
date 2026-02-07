if (oPlayer.ammo < oPlayer.max_ammo && visible) {
	oPlayer.ammo = oPlayer.max_ammo;
	alarm[0] = 120;
	visible = false;
}