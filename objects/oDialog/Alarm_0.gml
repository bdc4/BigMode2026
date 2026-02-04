/// Alarm 0
// TESTING
var d = dialog_get();

// Dunkey-esque Pizza Boss lines
var sample_dialog = [
    ["Pizza Boss", "Alright listen up.\nThis pizza is the main character.", sPizzaDogPortrait, 0],
    ["Pizza Boss", "If this pizza gets cold,\nI'm uninstalling you.", sPizzaDogPortrait, 0],
    ["Pizza Boss", "Drive like your GPA depends on it.\nBecause it does.", sPizzaDogPortrait, 0],
    ["Pizza Boss", "I ordered SPEED.\nThis is not speed.", sPizzaDogPortrait, 0],
    ["Pizza Boss", "This pizza better arrive hot,\nor emotionally warm.", sPizzaDogPortrait, 0],
    ["Pizza Boss", "Every second you waste, a pizza angel loses its wings.", sPizzaDogPortrait, 0],
    ["Pizza Boss", "I once fired a guy for less than this.", sPizzaDogPortrait, 0],
    ["Pizza Boss", "This is a delivery game.\nPlease begin delivering.", sPizzaDogPortrait, 0],
	["Pizza Boss", "I paid for EXPRESS delivery.\nThis is more like WALKING.", sPizzaDogPortrait, 0],
	["Pizza Boss", "That pizza has a family.\nMove.", sPizzaDogPortrait, 0],
	["Pizza Boss", "I have seen faster gameplay in a turn-based RPG.", sPizzaDogPortrait, 0],
	["Pizza Boss", "You are driving like this is your first video game.", sPizzaDogPortrait, 0],
	["Pizza Boss", "Fun fact:\nTime is money. You are broke.", sPizzaDogPortrait, 0],
	["Pizza Boss", "This delivery is being speedrun by a toddler.", sPizzaDogPortrait, 0],
	["Pizza Boss", "I hope you like refunds.\nBecause I don’t.", sPizzaDogPortrait, 0],
	["Pizza Boss", "I could’ve walked there by now.\nI am a dog.", sPizzaDogPortrait, 0],
	["Pizza Boss", "This pizza was hot in the tutorial.", sPizzaDogPortrait, 0],
	["Pizza Boss", "I’m not mad.\nI’m just incredibly disappointed.", sPizzaDogPortrait, 0],
	["Pizza Boss", "The customer ordered EXTRA FAST.\nCheck the receipt.", sPizzaDogPortrait, 0],
	["Pizza Boss", "This pizza has a destiny.\nYou are in the way.", sPizzaDogPortrait, 0],
	["Pizza Boss", "I’ve seen this one before.\nIt ends with cold pizza.", sPizzaDogPortrait, 0],
	["Pizza Boss", "I hired you for speed.\nNot vibes.", sPizzaDogPortrait, 0],
	["Pizza Boss", "If this pizza cools down,\nI cool down your paycheck.", sPizzaDogPortrait, 0],
	["Pizza Boss", "Drive like the oven is still watching.", sPizzaDogPortrait, 0],
	["Pizza Boss", "This is not a sightseeing tour.", sPizzaDogPortrait, 0],
	["Pizza Boss", "Somewhere out there...\n...a customer is hovering over one star.", sPizzaDogPortrait, 0]

];

// --- Pick a random dialog, but NOT the same as last time ---
if (!variable_global_exists("last_dialog_index")) {
    last_dialog_index = -1;
}

var idx;
var len = array_length(sample_dialog);

// Ensure we don't repeat the same line twice
repeat (10) {
    idx = irandom(len - 1);
    if (idx != last_dialog_index) break;
}

last_dialog_index = idx;

// Show dialog
var line = sample_dialog[idx];
d.dialog_show(line[0], line[1], line[2], line[3]);

// New dialog every 1–2 minutes
alarm[0] = random_range(1, 2) * 60 * 30;
