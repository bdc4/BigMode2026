// --- Intro sequence state ---
intro_phase = 0; // 0=publisher, 1=title bounce, 2=done

// Publisher splash (phase 0)
pub_text = "Space Club Games Presents...";

pub_fade_in  = room_speed * 3;  // fade in duration
pub_hold     = room_speed * 4;  // hold duration
pub_fade_out = room_speed * .5;  // fade out duration

pub_t = 0;
pub_text_alpha = 0;   // 0..1
pub_black_alpha = 1;  // 0..1 (black overlay)


// Title bounce
title_sprite = sTitle; // <-- your title sprite asset
title_x = 200;
title_y = -200;        // start off-screen above
title_vy = 0;

title_target_y = 120;  // where it comes to rest (GUI pixels)
title_grav = 1.2;      // falling accel
title_bounce = 0.55;   // bounce energy (0.35..0.7)
title_floor_damp = 0.86; // extra damping on each bounce
title_done_speed = 0.6;  // threshold to stop bouncing

// Optional: dim behind title briefly
title_dim = 0.0;

audio_play_sound(sndTheme,1,true);