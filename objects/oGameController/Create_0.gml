global.buildings = ds_list_create();
global.target_building = noone;
global.police_chase = false;


with (oBuilding) {
	ds_list_add(global.buildings, id);
}

scrPickNewTarget();


global.objectives = [
	"Park in front of Pizza Dog."
];

global.progress = 0;

global.current_objective = global.objectives[global.progress];

instance_create_layer(x,y,layer,oObjectiveTracker);