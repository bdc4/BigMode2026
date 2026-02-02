broken = false;

if (type == noone) {
	type = [sFireHydrant,sMailbox,sStopSign,sStreetlight][irandom(3)];
}

sprite_index = type;