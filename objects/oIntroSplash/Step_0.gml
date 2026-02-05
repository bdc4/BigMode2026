switch (intro_phase) {

    case 0:
       // -------------------------
		// 0) Publisher splash (fade in -> hold -> fade out)
		// -------------------------
		pub_t += 1;

		var t_in  = pub_fade_in;
		var t_hold= pub_hold;
		var t_out = pub_fade_out;

		if (pub_t <= t_in) {
		    // Fade IN text only (black stays solid)
		    var u = pub_t / max(1, t_in); // 0..1
		    pub_text_alpha  = u;
		    pub_black_alpha = 1;
		}
		else if (pub_t <= t_in + t_hold) {
		    // Hold
		    pub_text_alpha  = 1;
		    pub_black_alpha = 1;
		}
		else {
		    // Fade OUT both
		    var u2 = (pub_t - (t_in + t_hold)) / max(1, t_out); // 0..1
		    u2 = clamp(u2, 0, 1);

		    pub_text_alpha  = 1 - u2;
		    pub_black_alpha = 1 - u2;

		    if (u2 >= 1) {
		        intro_phase = 1; // move to title bounce
		        // init title start here if you already do that on phase change
		        title_x = display_get_gui_width() * 0.5;
		        title_y = -sprite_get_height(title_sprite) - 40;
		        title_vy = 0;
		        title_dim = 0.35;
		    }
		}

		// Optional skip
		if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_left)) {
		    intro_phase = 1;

		    // init title start
		    title_x = display_get_gui_width() * 0.5;
		    title_y = -sprite_get_height(title_sprite) - 40;
		    title_vy = 0;
		    title_dim = 0.35;

		    pub_text_alpha = 0;
		    pub_black_alpha = 0;
		}

    break;

    // -------------------------
    // 1) Title bounce
    // -------------------------
    case 1:
        // Gravity
        title_vy += title_grav;
        title_y  += title_vy;

        // Floor collision + bounce
        if (title_y >= title_target_y) {
            title_y = title_target_y;

            // bounce with damping
            title_vy = -title_vy * title_bounce;
            title_vy *= title_floor_damp;

        }

        // Dim eases away if you want
        title_dim = lerp(title_dim, 0, 0.05);

        // Skip
        if (keyboard_check_pressed(vk_anykey) || mouse_check_button_pressed(mb_left)) {
            title_y = title_target_y;
            title_vy = 0;
            title_dim = 0;
            intro_phase = 2;
        }
    break;
}
