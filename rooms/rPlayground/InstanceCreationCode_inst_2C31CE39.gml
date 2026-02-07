
menu_options = ["Upgrade Pizza Storage", "Cancel"];
callbacks = [
    function(_t) { // Upgrade Pizza Storage
        if (variable_instance_exists(oPlayer.id, "max_ammo")) {
           if (oPlayer.money >= 100) {
			   oPlayer.max_ammo += 1;
			   oPlayer.money -= 100;
		   }
        }
    },
    //function(_t) { // Repair
    //    if (variable_instance_exists(p, "health") && variable_instance_exists(p, "max_health")) {
    //        p.health = p.max_health;
    //    }
    //},
    function(_t) { /* Cancel */ }
];