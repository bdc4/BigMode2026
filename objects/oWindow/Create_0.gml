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
sndWindowBreak[6] = sndWindowBreak07;
sndWindowBreak[7] = sndWindowBreak08;
sndWindowBreak[8] = sndWindowBreak09;

brokenSound = choose(sndWindowBreak01, sndWindowBreak02, sndWindowBreak03, sndWindowBreak04, sndWindowBreak05, sndWindowBreak06, sndWindowBreak07, sndWindowBreak08, sndWindowBreak09);