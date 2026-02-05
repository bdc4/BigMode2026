var spr = sprite_index;
var sub = image_index;

// Sprite dimensions
var sw = sprite_get_width(spr);
var sh = sprite_get_height(spr);

// Draw position (top-left anchored). If your origin isn’t left/top, adjust accordingly.
var x0 = x - sprite_get_xoffset(spr);
var y0 = y - sprite_get_yoffset(spr);

// Time
var t = current_time * 0.001; // seconds-ish

// How many strips
var w = max(1, strip_w);
for (var sx = 0; sx < sw; sx += w) {

    // Normalized 0..1 across the flag
    var u = sx / (sw - 1);

    // Displacement increases away from pole (u factor)
    var offset_y =
        sin((sx * wave_freq) + (t * wave_speed * 60)) // wave
        * wave_amp
        * u;

    // Optional: add a second smaller ripple to make it feel less “perfect”
    offset_y +=
        sin((sx * wave_freq * 2.3) + (t * wave_speed * 95))
        * (wave_amp * 0.25)
        * u;

    // Draw a vertical slice from the sprite
    // (x, y, w, h, src_x, src_y, src_w, src_h)
    draw_sprite_part(
        spr, sub,
        sx, 0, min(w, sw - sx), sh,
        x0 + sx, y0 + offset_y
    );
}
