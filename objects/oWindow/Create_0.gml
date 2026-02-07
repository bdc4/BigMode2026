event_inherited()

image_index = irandom(sprite_get_number(sprite_index));

//array for broken window sounds
sndWindowBreak = []

//sounds for broken window
sndWindowBreak[0] = sndWindowBreak01;
sndWindowBreak[1] = sndWindowBreak02;
sndWindowBreak[2] = sndWindowBreak03;
sndWindowBreak[3] = sndWindowBreak04;
sndWindowBreak[4] = sndWindowBreak05;
sndWindowBreak[5] = sndWindowBreak06; 

brokenSound = choose(sndWindowBreak01, sndWindowBreak02, sndWindowBreak03, sndWindowBreak04, sndWindowBreak05, sndWindowBreak06);