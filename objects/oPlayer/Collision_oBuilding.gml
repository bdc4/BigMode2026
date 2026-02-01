if (global.target_building != noone && string(global.target_building.id) == string(other.id)) {
	show_debug_message("COLIDED WITH TARGET BUILDING!");
	global.target_building = noone;
	other.is_target = false;
}