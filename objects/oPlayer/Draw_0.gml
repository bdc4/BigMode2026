
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
    (abs(hsp + vsp)) / max_speed
);
