if (wasBroken != broken) {
	// handle break logic
	
	if (!wasBroken && broken) { // CHANGED FROM UNBROKEN TO BROKEN
		if brokenSound audio_play_sound(brokenSound,1,false);
		if (sprite_index == sFireHydrant) {
			passiveSound = audio_play_sound_at(sndFireHydrantBreakGeyserLOOP,x,y,0,100,220,1,true,2)
		}
		oPlayer.money += 1;
	}
	
	else if (!broken && wasBroken) { // CHANGED FROM BROKEN TO UNBROKEN (REPAIRED)
		if (passiveSound) audio_stop_sound(passiveSound)
	}
}