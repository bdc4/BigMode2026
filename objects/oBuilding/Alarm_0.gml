var c = irandom(99);
if (c > 50 && id != INSTANCE_PIZZA_DOG.id) {
	wantsPizza = true;
} else {
	wantsPizza = false;
}

pizzaTimer = room_speed * irandom_range(45, 60) * (1/multiplier);
if (!wantsPizza) pizzaTimer = pizzaTimer/2;
pizza_timer_max = pizzaTimer;
alarm[0] = pizzaTimer;