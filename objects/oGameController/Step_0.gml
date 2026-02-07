global.houses_wanting_pizza = 0;

with (oBuilding) {
	if (wantsPizza) {
		global.houses_wanting_pizza++;
	}
}