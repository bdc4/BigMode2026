// Find player overlap
var p = instance_place(x, y, player_obj);

if (!instance_exists(oPopupMenu)) _menu_open = false;

player_present = false;

if (p == noone) {
    _stop_timer = 0;
    _menu_open = false;
    exit;
}

player_present = true;

// Compute player speed magnitude
var spd = 0;
if (variable_instance_exists(p, "hsp") && variable_instance_exists(p, "vsp")) {
    spd = point_distance(0, 0, p.hsp, p.vsp);
} else if (variable_instance_exists(p, "speed")) {
    spd = p.speed;
}

// Track "stopped" time while in zone
if (spd <= stop_speed) _stop_timer++;
else _stop_timer = 0;

// Only allow opening after they've been stopped long enough
var can_open = (_stop_timer >= stop_frames);

// Press Ctrl (either left or right)
var ctrl_pressed = keyboard_check_pressed(vk_control)
                || keyboard_check_pressed(vk_lcontrol)
                || keyboard_check_pressed(vk_rcontrol);

if (can_open && ctrl_pressed && !_menu_open) {

    // Optional: close any existing menus so we only have one
    with (oPopupMenu) instance_destroy();

    // Build callbacks (functions) – zone can do different stuff per option
    // var callbacks = callbacks;

    // Open menu (uses the popup_open helper from earlier)
    popup_open(p, menu_title, menu_options, callbacks);

    _menu_open = instance_exists(oPopupMenu);
}
