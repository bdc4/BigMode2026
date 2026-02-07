timer -= 1;

var _sign = amount >= 0 ? "+" : "-";
var txt = _sign + "$" + string(abs(amount));

var yy = y - 32 - offset + ((timer / timer_max) * 32);

// styling
draw_set_font(fntMain);

// --- OUTLINE ---
draw_set_color(c_black);
draw_text(x - 1, yy, txt);
draw_text(x + 1, yy, txt);
draw_text(x, yy - 1, txt);
draw_text(x, yy + 1, txt);

// --- MAIN TEXT ---
draw_set_color(_sign == "+" ? c_lime : c_red);
draw_text(x, yy, txt);

// reset
draw_set_color(c_white);

if (timer <= 0) instance_destroy();
