timer -= 1;

var _sign = amount >= 0 ? "+" : "-";

draw_set_font(fntMain);
draw_set_color(_sign == "+" ? c_lime : c_red);
draw_text(x, y-32-offset + ((timer/timer_max)*32), _sign+"$"+string(abs(amount)));
draw_set_color(c_white);

if (timer <= 0) instance_destroy();
