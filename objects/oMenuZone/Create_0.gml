// --- Settings ---
player_obj = oPlayer;

stop_speed = 0.25;     // how slow is "stopped"
stop_frames = 10;      // must be stopped this many steps to allow menu

// --- State ---
_stop_timer = 0;
_menu_open = false;

// Menu content (edit per-zone)
menu_title = "Menu Zone";
menu_options = ["Refill Ammo", "Repair", "Cancel"];

player_present = false;

callbacks = [
    function(_t) { // Refill Ammo
        if (variable_instance_exists(p, "ammo") && variable_instance_exists(p, "max_ammo")) {
            p.ammo = p.max_ammo;
        }
    },
    function(_t) { // Repair
        if (variable_instance_exists(p, "health") && variable_instance_exists(p, "max_health")) {
            p.health = p.max_health;
        }
    },
    function(_t) { /* Cancel */ }
];