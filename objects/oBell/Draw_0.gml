/// oBell : Draw

event_inherited()

// Draw tongue (behind bell)
draw_sprite_ext(
    sSchoolBellHammer,
    0,
    x,
    y,
    1, 1,
    tongue_angle,
    c_white,
    1
);

// Draw bell body

draw_self();
