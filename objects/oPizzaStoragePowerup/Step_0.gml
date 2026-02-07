if (instance_place(x,y,oPlayer)) {
	if (oPlayer.money >= 100) {
		text = "Press SHIFT to Upgrade Pizza Storage";
	
		if (keyboard_check_pressed(vk_shift)) {
			oPlayer.max_ammo += 1;
			oPlayer.money -= 100;
			//audio_play_sound(sndRegister, 1, 0);
		}
	
	} else {
		text = "Need more money!";
	}
} else {
	text = "";
}