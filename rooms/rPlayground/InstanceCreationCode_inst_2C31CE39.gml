
menu_options = ["Upgrade Pizza Storage", "Repair", "Cancel"];
callbacks = [
    function(_t) { // Upgrade Pizza Storage
        if (variable_instance_exists(oPlayer.id, "max_ammo")) {
            oPlayer.max_ammo += 1;
        }
    },
    function(_t) { // Repair
        if (variable_instance_exists(p, "health") && variable_instance_exists(p, "max_health")) {
            p.health = p.max_health;
        }
    },
    function(_t) { /* Cancel */ }
];