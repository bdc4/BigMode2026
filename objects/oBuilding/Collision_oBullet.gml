if (wantsPizza) {
	var m = 0;
	m += 10;
	
	// calculate tip
	m += floor(ratio * 5)
	
	// calculate speed bonus
	if (oPlayer.time_since_delivery < 5*room_speed) {
		m += floor((oPlayer.time_since_delivery/(5*room_speed)) * 8);
	}
	
	m = m * multiplier;
	
	oPlayer.money += m;
	
	oPlayer.time_since_delivery = 0;
	
	wantsPizza = false;
}