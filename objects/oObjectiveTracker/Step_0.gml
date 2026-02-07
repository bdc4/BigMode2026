
// OBJECTIVE PROGRESS
var d = dialog_get()
switch (global.progress) {
	case 0: // PARK IN FRONT OF PIZZA DOG
		var _pd = INSTANCE_PIZZA_DOG
		oa = [_pd.x, _pd.y + sprite_get_height(_pd.sprite_index),
		_pd.x + sprite_get_width(_pd.sprite_index),  _pd.y + sprite_get_height(_pd.sprite_index)*2
		]
		if collision_rectangle(oa[0],oa[1],oa[2],oa[3],oPlayer,false,false) {
			park_timer++;
			if (park_timer > 2 * room_speed) {
				global.progress++;
				d.dialog_show("Pizza Boss", "About time you showed up!\nTalk to the mechanic and upgrade your Pizza Storage!\nHere's $100 to get you started.", sPizzaDogPortrait, 0)
				oPlayer.money += 100;
			}
		} else {
			park_timer = 0;
		}
	break;
	
	case 1: // UPGRADE PIZZA STORAGE
		if (oPlayer.max_ammo > 0) {
			global.progress++;
			d.dialog_show("Pizza Boss", "Good work.\nNow come back and pick up the pizza before it gets cold!", sPizzaDogPortrait, 0)
		}
	break;
	
	case 2: // PICK UP PIZZA
		if (oPlayer.ammo > 0) {
			global.progress++;
			d.dialog_show("Pizza Boss", "Time for your first delivery!\nDrive to the FUNeral building!", sPizzaDogPortrait, 0)
		}
	break;
	
	case 3: // DELIVER TO FUNERAL HOME
		var _fh = INSTANCE_FUNERAL_HOME;
		oa = [_fh.x, _fh.y + sprite_get_height(_fh.sprite_index),
		_fh.x + sprite_get_width(_fh.sprite_index),  _fh.y + sprite_get_height(_fh.sprite_index)*2
		]
		
		if (!show_box && (collision_rectangle(oa[0], oa[1], oa[2], oa[3], oPlayer, false, false))) {
			d.dialog_show("Pizza Boss", "Click on the FUNeral Home!", sPizzaDogPortrait, 0)
			show_box = true;
		}
		
		if (collision_rectangle(oa[0], oa[1], oa[2], oa[3], oBullet, false, false)) {
			global.progress++;
			show_box = false;
			d.dialog_show("Pizza Boss", "Nice job!\nCome back and get more pizza.", sPizzaDogPortrait, 0)
		}
	break;
	
	case 4: // PICK UP PIZZA
		if (oPlayer.ammo > 0) {
			global.progress++;
			d.dialog_show("Pizza Boss", 
			"Business is booming!!\nHouses all over town want Pizza Dog.\nFind one and deliver them a Pizza, quick!"+
			"\nHouses wanting pizza will have an indicator on them!\nOh, and if you ever run out of pizza...\nJust come back here and pick more up!",
			sPizzaDogPortrait, 0)
		}
	break;
	
	case 5: // EARN $100
		if (oPlayer.money >= 100 && !show_box) {
			d.dialog_show("Pizza Boss", "Nice deliveries!\nNow that you've earned $100, you should upgrade your Pizza Storage!\nThat way you don't have to keep driving back here for every single pizza!\n...Not that I mind the company <3", sPizzaDogPortrait, 0)
			show_box = true;
			global.progress++;
		}
		
	break;
	
	case 6: // UPGRADE MAX AMMO TO 2
		if (oPlayer.max_ammo > 1) {
			global.progress++;
			d.dialog_show("Pizza Boss", "So much room for deliveries!\nThe pizza (and the customers!) are waiting for you!", sPizzaDogPortrait, 0)
			show_box = false;
		}
	break;
	
	case 7: // UPGRADE MAX AMMO TO 3
		if (oPlayer.max_ammo > 2) {
			global.progress++;
			d.dialog_show("Pizza Boss", "*slaps car* This baby can fit so many pepperonis!!\nYou know the drill: come pick up the pizzas and make more deliveries!", sPizzaDogPortrait, 0)
		}
		show_box = false;
	break;
	
	case 8: // Earn $500
		if (oPlayer.money >= 500 && show_box == false) {
			show_box = true;
			d.dialog_show("Pizza Boss", "Education is expensive but worth it!\nTake that $500 to the school and upgrade your Pizza Multiplier!\nYou'll get more money for each delivery.", sPizzaDogPortrait, 0)
		}
		if (oPlayer.multiplier > 1) {
			global.progress++;
			show_box = false;
			d.dialog_show("Pizza Boss", "Word is spreading around Pizza Town!\nWe're getting quite popular.\nThat means we can start charging more for our pizzas!\nBut it also means our customers will have higher expectations!", sPizzaDogPortrait, 0)
		}
	break;
	
	case 9: // DO NOT EARN MORE THAN $9999
		if (oPlayer.money >= 9999 && !show_box) {
			d.dialog_show("Pizza Boss", "UH OH!\nYOU'RE TOO RICH FOR PIZZA TOWN!!!\nGET 'EM BOYS!\n(...I'll still keep the pizza coming though!)", sPizzaDogPortrait, 0)
			global.police_chase = true;
			with (oChaseFX) enabled = true;
			show_box = true;
			global.progress++;
		}
	break;
	
	default:
		oa = [0,0,0,0]
		
	break;
}