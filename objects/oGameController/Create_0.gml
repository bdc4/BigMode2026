global.buildings = ds_list_create();
global.target_building = noone;

with (oBuilding) {
	ds_list_add(global.buildings, id);
}

scrPickNewTarget();