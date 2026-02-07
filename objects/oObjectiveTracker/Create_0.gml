
oa = [0,0,0,0]
park_timer = 0;
show_box = false;

global.objectives = [
	// 0
	"Park in front of Pizza Dog.",
	// 1
	"Go to the the Auto Repair shop and upgrade your Pizza Storage",
	// 2
	"Pick up the Pizza from Pizza Dog",
	// 3
	"Drive to the FUNeral building.\n--Click on the front of it to deliver a pizza!",
	// 4
	"Pick up more pizza from Pizza Dog",
	// 5
	"Earn $100",
	// 6
	"Upgrade your Pizza Storage at the Auto Repair shop.",
	// 7
	"Upgrade your Pizza Storage to 3",
	// 8
	"Earn $500 and upgrade your Pizza skills at the School",
	// 9
	"ABSOLUTELY DO NOT EARN MORE THAN $9999",
	// 10
	"Evade the police!"
];

global.progress = 0;

global.current_objective = global.objectives[global.progress];