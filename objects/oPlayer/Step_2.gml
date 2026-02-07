if (money_start != money) {
	money_diff = money - money_start;
	var m = instance_create_layer(x,y,"GUI",oMoneyDiff);
	m.amount = money_diff;
}