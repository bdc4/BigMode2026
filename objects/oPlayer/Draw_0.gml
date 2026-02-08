if (headlight_on)
{
    // ---- beam direction (front of car) ----
    var dir = facing + tip_angle_offset;

    // ---- start point 16px in front of sprite center ----
    // If origin is centered, this is your “muzzle” point.
    var sx = x + lengthdir_x(16, dir);
    var sy = y + lengthdir_y(16, dir);

    // ---- beam end point ----
    var ex = sx + lengthdir_x(headlight_len, dir);
    var ey = sy + lengthdir_y(headlight_len, dir);

    // ---- beam corners (near + far widths) ----
    var nx = lengthdir_x(headlight_w_near * 0.5, dir + 90);
    var ny = lengthdir_y(headlight_w_near * 0.5, dir + 90);

    var fx = lengthdir_x(headlight_w_far * 0.5, dir + 90);
    var fy = lengthdir_y(headlight_w_far * 0.5, dir + 90);

    var nLx = sx + nx,  nLy = sy + ny;
    var nRx = sx - nx,  nRy = sy - ny;

    var fLx = ex + fx,  fLy = ey + fy;
    var fRx = ex - fx,  fRy = ey - fy;

    // ---- soft “glow” at the lamp ----
    draw_set_alpha(headlight_alpha * 1.2);
    draw_set_color(make_color_rgb(255, 245, 170)); // soft yellow
    draw_circle(sx, sy, 10, false);

    // ---- main cone (two triangles) ----
    draw_set_alpha(headlight_alpha);
    draw_triangle(nLx, nLy, fLx, fLy, fRx, fRy, false);
    draw_triangle(nLx, nLy, fRx, fRy, nRx, nRy, false);

    // ---- extra soft layer (wider + dimmer) ----
    draw_set_alpha(headlight_alpha * 0.55);
    var w2n = headlight_w_near * 1.6;
    var w2f = headlight_w_far  * 1.35;

    nx = lengthdir_x(w2n * 0.5, dir + 90);
    ny = lengthdir_y(w2n * 0.5, dir + 90);
    fx = lengthdir_x(w2f * 0.5, dir + 90);
    fy = lengthdir_y(w2f * 0.5, dir + 90);

    nLx = sx + nx; nLy = sy + ny;
    nRx = sx - nx; nRy = sy - ny;
    fLx = ex + fx; fLy = ey + fy;
    fRx = ex - fx; fRy = ey - fy;

    draw_triangle(nLx, nLy, fLx, fLy, fRx, fRy, false);
    draw_triangle(nLx, nLy, fRx, fRy, nRx, nRy, false);

    // reset
    draw_set_alpha(1);
    draw_set_color(c_white);
}


//image_angle = visual_facing; // or facing if you don't want smoothing
draw_self();

// ------------------------------------------------------------
// FACING DIRECTION INDICATOR (sprite-based)
// ------------------------------------------------------------
var dir = visual_facing;

// Sprite half-extent in facing direction
var sw = sprite_width  * image_xscale;
var sh = sprite_height * image_yscale;

var front_dist =
    abs(cos(degtorad(dir))) * (sw * 0.5) +
    abs(sin(degtorad(dir))) * (sh * 0.5);

// Distance from sprite front
var offset = front_dist + 16;

// Position at front
var fx = x + lengthdir_x(offset, dir);
var fy = y + lengthdir_y(offset, dir);

// Draw the triangle sprite
draw_sprite_ext(
    sSchoolFlag,
    0,
    fx,
    fy,
    0.25,    // x scale
    0.25,    // y scale
    dir,    // rotation
    c_white,
    demo_mode ? 0 : 1
	//(abs(hsp + vsp)) / max_speed
);


if (!demo_mode && tooltip_timer < room_speed * 10) {

	draw_set_color(c_white);
	draw_rectangle(x,y-30,x+140,y-100,false)
	draw_set_color(c_black);
	draw_text(x, y-100, "A/D to Steer\nSPACE to Drive\nCtrl to Reverse")
	draw_set_colour(c_white)
	tooltip_timer++;
}