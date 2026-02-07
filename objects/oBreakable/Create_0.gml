event_inherited();

broken = false;
brokenSound = noone;

if (type == noone && sprite_index == noone) {
	type = [sFireHydrant,sMailbox,sStopSign,sStreetlight][irandom(3)];
	sprite_index = type;
} else {
	type = sprite_index;
}

