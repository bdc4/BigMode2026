global.buildings = ds_list_create();
global.target_building = noone;
global.police_chase = false;


with (oBuilding) {
	ds_list_add(global.buildings, id);
}

scrPickNewTarget();