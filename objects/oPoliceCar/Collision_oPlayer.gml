
// check if all achievements unlocked and if so, go to rGoodBoy
var a = oAchievements.ach;
allUnlocked = a[? "bib"].unlocked && a[? "cook"].unlocked && a[? "bell"].unlocked && a[? "bby"].unlocked && a[? "rts"].unlocked;

instance_deactivate_all();

if (allUnlocked) {
	room_goto(rGoodBoy)
}
else {
	room_goto(rGameOver)
}