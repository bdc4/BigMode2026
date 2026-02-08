if (barks > 5) exit;

var b = choose(sndPhoneDogBark01,sndPhoneDogBark02,sndPhoneDogBark03,sndPhoneDogBark04,sndPhoneDogBark05,sndPhoneDogBark06,sndPhoneDogBark07,sndPhoneDogBark08)
audio_play_sound(b,3,false);

barks++;
alarm[1] = 10;