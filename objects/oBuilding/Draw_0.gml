event_inherited();
draw_self();

if (!wantsPizza) exit;

// ------------------------------------------------------------
// Pizza timer (clockwise wipe)
// ------------------------------------------------------------

// Position above building
var px = x + sprite_width * 0.5;
var py = y + 60;

// Timer progress (1 → 0)
var t = clamp(alarm[0] / pizza_timer_max, 0, 1);

// Full circle = 360 degrees, clockwise from top
var end_angle = -90 + (360 * t);

// Pizza size
var r = sprite_get_width(sPizza) * 0.5;

// Draw base pizza (faded background)
draw_set_alpha(0.25);
draw_sprite(sPizza, 0, px, py);

// Draw filled portion
draw_set_alpha(1);
draw_set_color(c_white);

// Center
var cx = px;
var cy = py;

// Step size controls smoothness (lower = smoother, more triangles)
var step = 6;

for (var a = -90; a < end_angle; a += step)
{
    var a2 = min(a + step, end_angle);

    var x1 = cx;
    var y1 = cy;

    var x2 = cx + lengthdir_x(r, a);
    var y2 = cy + lengthdir_y(r, a);

    var x3 = cx + lengthdir_x(r, a2);
    var y3 = cy + lengthdir_y(r, a2);

    draw_triangle(x1, y1, x2, y2, x3, y3, false);
}

// Mask pizza sprite into the wedge
gpu_set_blendmode(bm_add);
draw_sprite(sPizza, 0, px, py);
gpu_set_blendmode(bm_normal);

// Reset
draw_set_alpha(1);
draw_set_color(c_white);
