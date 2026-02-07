if (instance_place(x,y,oPlayer)) {
	if (oPlayer.money >= cost) {
		text = "Press SHIFT to Upgrade Pizza Multiplier";
	
		if (keyboard_check_pressed(vk_shift)) {
			oPlayer.multiplier += 1;
			oPlayer.money -= cost;
			//audio_play_sound(sndRegister, 1, 0);
		}
	
	} else {
		text = "Need more money!";
	}
} else {
	text = "";
}