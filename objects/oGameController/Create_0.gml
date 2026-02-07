global.buildings = ds_list_create();
global.target_building = noone;
global.police_chase = false;
global.houses_wanting_pizza = 0;


with (oBuilding) {
	if (oBuilding.id != INSTANCE_PIZZA_DOG)
		ds_list_add(global.buildings, id);
}

scrPickNewTarget();

instance_create_layer(x,y,layer,oObjectiveTracker);