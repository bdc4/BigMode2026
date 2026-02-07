var c = irandom(99);
if (c > 80) { // TODO: Scale off of popularity
	wantsPizza = true;
} else {
	wantsPizza = false;
}

pizzaTimer = room_speed * irandom_range(45, 60);
pizza_timer_max = pizzaTimer;
alarm[0] = pizzaTimer;