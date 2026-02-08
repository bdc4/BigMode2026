event_inherited();

broken = false;
brokenSound = noone;

if (type == noone && sprite_index == noone) {
	type = [sFireHydrant,sMailbox,sStopSign,sStreetlight][irandom(3)];
	sprite_index = type;
} else {
	type = sprite_index;
}

var t = [
		[sFireHydrant, sndFireHydrantBreak],
		[sMailbox, choose(sndMailboxBreak01,sndMailboxBreak02,sndMailboxBreak03)],
		[sStopSign, choose(sndStopSignBreak01,sndStopSignBreak02,sndStopSignBreak03)],
		[sStreetlight, choose(sndLamppostBreak01,sndLamppostBreak02,sndLamppostBreak03)]
	]

array_foreach(t, function(i) {
	if (type == i[0]) {
		brokenSound = i[1];
	}
})

passiveSound = noone;