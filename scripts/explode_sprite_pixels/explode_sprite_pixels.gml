function explode_sprite_pixels(_spr, _subimg, _x, _y, _power)
{
    var w = sprite_get_width(_spr);
    var h = sprite_get_height(_spr);

    var surf = surface_create(w, h);
    surface_set_target(surf);
    draw_clear_alpha(c_black, 0);
    draw_sprite(_spr, _subimg, 0, 0);
    surface_reset_target();

    var buf = buffer_create(w * h * 4, buffer_fixed, 1);
    buffer_get_surface(buf, surf, 0);

    for (var yy = 0; yy < h; yy++) {
        for (var xx = 0; xx < w; xx++) {

            var i = (yy * w + xx) * 4;
            var a = buffer_peek(buf, i + 3, buffer_u8);

            if (a > 10 && random(1) < 0.25) { // density control
                var c = buffer_peek(buf, i, buffer_u32);

                var px = _x + xx - w * 0.5;
                var py = _y + yy - h * 0.5;

               // Launch pixel (temporarily set particle color)
				part_type_colour1(global.pt_cheese_px, c);
				part_particles_create(global.ps_pizza, px, py, global.pt_cheese_px, 1);

            }
        }
    }

    buffer_delete(buf);
    surface_free(surf);
}
