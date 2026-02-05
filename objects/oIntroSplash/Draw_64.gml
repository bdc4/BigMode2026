var gw = display_get_gui_width();
var gh = display_get_gui_height();

// -------------------------
// Publisher phase drawing
// -------------------------
if (intro_phase == 0) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    // Black screen
    draw_set_alpha(pub_black_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, gw, gh, false);

    // Publisher text fades in/out on top
    draw_set_alpha(pub_text_alpha);
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(gw * 0.5, gh * 0.5, pub_text);

    // Reset
    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}


// -------------------------
// Title bounce + title screen drawing
// -------------------------
if (intro_phase == 1 || intro_phase == 2) {

    // Optional dim behind title
    if (title_dim > 0.001) {
        draw_set_alpha(title_dim);
        draw_set_color(c_black);
        draw_rectangle(0, 0, gw, gh, false);
        draw_set_alpha(1);
    }

    // Draw title sprite
    draw_sprite_ext(
        title_sprite, 0,
        title_x, title_y,
        1, 1,
        0,
        c_white,
        1
    );

    // -------------------------
    // "Press SPACE to Start!" (ONLY during title screen)
    // -------------------------
    if (intro_phase == 1) {

        var t = current_time * 0.001;
        var a = 0.35 + 0.65 * (0.5 + 0.5 * sin(t * 6)); // pulsing alpha

        var msg = "PRESS SPACE TO START!";

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);

        // Shadow
        draw_set_alpha(a * 0.9);
        draw_set_color(c_black);
        draw_text(gw * 0.5 + 2, gh - 70 + 2, msg);

        // Text
        draw_set_alpha(a);
        draw_set_color(c_white);
        draw_text(gw * 0.5, gh - 70, msg);

        // Reset
        draw_set_alpha(1);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
}

