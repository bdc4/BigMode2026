draw_self();

if (state == 2 && repair_time > 0)
{
    var t = clamp(repair_t / repair_time, 0, 1);

    // bar position above head
    var bar_w = 28;
    var bar_h = 5;
    var bx = x - bar_w * 0.5;
    var by = y - sprite_get_height(sprite_index) * 0.5 - 12;

    // background
    draw_set_alpha(0.75);
    draw_set_color(c_black);
    draw_rectangle(bx-1, by-1, bx+bar_w+1, by+bar_h+1, false);

    // fill
    draw_set_alpha(1);
    draw_set_color(c_lime);
    draw_rectangle(bx, by, bx + bar_w * t, by + bar_h, false);

    draw_set_color(c_white);
    draw_rectangle(bx, by, bx + bar_w, by + bar_h, true);
}

if (!debug_draw_path) exit;

// Draw A* path nodes
var n = array_length(path_x);

if (n > 0)
{
    draw_set_alpha(1);
    draw_set_color(c_lime);

    // Draw node points
    for (var i = 0; i < n; i++)
    {
        draw_circle(path_x[i], path_y[i], 4, false);
    }

    // Draw connecting lines
    for (var i = 0; i < n - 1; i++)
    {
        draw_line(path_x[i], path_y[i], path_x[i + 1], path_y[i + 1]);
    }

    // Highlight current target node
    if (path_i < n)
    {
        draw_set_color(c_yellow);
        draw_circle(path_x[path_i], path_y[path_i], 6, false);
    }
}

// Draw final park target
draw_set_color(c_red);
draw_circle(park_x, park_y, 6, false);

draw_set_color(c_white);