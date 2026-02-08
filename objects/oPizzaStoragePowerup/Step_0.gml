if (instance_place(x,y,oPlayer)) {
	if (oPlayer.money >= cost) {
		text = "Press SHIFT to Upgrade Pizza Storage\n($" + string(cost) + ")";
	
		if (keyboard_check_pressed(vk_shift)) {
			oPlayer.max_ammo += 1;
			oPlayer.money -= cost;
			//audio_play_sound(sndRegister, 1, 0);
		}
	
	} else {
		text = "Come back in ten years!\n(Need $" + string(cost) + " for this)";
	}
} else {
	text = "";
}