/// oPizzaBullet : Draw

// Normalized height (0 = ground, 1 = apex)
var h = clamp(z / max_z, 0, 1);

// SHADOW SCALE (smaller when high)
var sh = clamp(.75 - h, 0.5, 1.25);

// SHADOW OFFSET (lower on screen when high)
var shadow_drop = lerp(0, 24, h); // 0px at ground, 24px at apex (tune)

// SHADOW (on ground)
draw_set_alpha(0.35 * sh);
draw_set_color(c_black);

// draw ellipse shadow, pushed down by shadow_drop
draw_ellipse(
    x - 40 * sh,
    (y + shadow_drop) - 20 * sh,
    x + 40 * sh,
    (y + shadow_drop) + 20 * sh,
    false
);

draw_set_alpha(1);
draw_set_color(c_white);

// PIZZA (lifted toward camera)
draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y - z,
    1,
    1,
    image_angle,
    c_white,
    1
);
