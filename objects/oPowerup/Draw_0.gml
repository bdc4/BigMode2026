var yy = base_y + sin(current_time * 0.001 * 60 * bob_speed + bob_phase) * bob_amp;
draw_sprite_ext(sprite_index, image_index, x, yy, image_xscale, image_yscale, image_angle, c_white, image_alpha);
