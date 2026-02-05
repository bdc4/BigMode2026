if (oPlayer.ammo < oPlayer.max_ammo) {
	oPlayer.ammo += amount;
	oPlayer.ammo = clamp(oPlayer.ammo, 0, oPlayer.max_ammo)
	alarm[0] = 300;
	visible = false;
}