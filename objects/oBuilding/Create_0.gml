event_inherited()

is_target = false;
deactivated = false;
wantsPizza = false;
pizzaTimer = 0;

pizza_timer_max = -1;

function set_pizza() {
	wantsPizza = true;
	pizzaTimer = room_speed * 60;
}
