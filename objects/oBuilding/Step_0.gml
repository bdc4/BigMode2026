// Inherit the parent event
event_inherited();

if (!wantsPizza && global.progress >= 5 && alarm[0] == -1) {
	// chance that the house wants pizza
	alarm[0] = 1;
}

multiplier = oPlayer.multiplier;