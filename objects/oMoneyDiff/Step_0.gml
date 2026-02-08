if (abs(amount) >= 10 && snd == noone) {
	var __snd = amount < 0 ? sndCarUpgrade : sndMoneyEarned;
	snd = audio_play_sound(__snd,2,false)
}