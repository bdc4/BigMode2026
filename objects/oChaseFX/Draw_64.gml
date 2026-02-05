/// oChaseFX : Draw GUI
if (!enabled) exit;

var gw = display_get_gui_width();
var gh = display_get_gui_height();

// --- 1) DIM WHOLE SCREEN ---
draw_set_alpha(dim_alpha);
draw_set_color(c_black);
draw_rectangle(0, 0, gw, gh, false);
draw_set_alpha(1);

// Time (seconds-ish)
var t = current_time * 0.001;

// --- 2) LIGHT MOTION / FLASHING ---
// Alternate intensity
var phase = sin(t * flash_speed);            // -1..1
var red_i  = max(0,  phase);                 // 0..1
var blue_i = max(0, -phase);                 // 0..1

// Sweep positions across screen (slight offset so they’re not identical)
var sx = (sin(t * sweep_speed) * 0.5 + 0.5) * gw;
var sy = (cos(t * (sweep_speed * 0.8)) * 0.5 + 0.5) * gh;

// Offset the two lights so they feel like a bar
var off = 120;
var rx = clamp(sx - off, 0, gw);
var bx = clamp(sx + off, 0, gw);
var ry = clamp(sy, 0, gh);
var by = clamp(sy + 30, 0, gh);

// --- 3) ADDITIVE LIGHTS ---
gpu_set_blendmode(bm_add);

// Big soft “glow” rings
draw_set_alpha(0.55 * red_i);
draw_set_color(c_red);
draw_circle(rx, ry, light_r2, false);
draw_set_alpha(0.90 * red_i);
draw_circle(rx, ry, light_r1, false);

draw_set_alpha(0.55 * blue_i);
draw_set_color(make_color_rgb(60, 120, 255));
draw_circle(bx, by, light_r2, false);
draw_set_alpha(0.90 * blue_i);
draw_circle(bx, by, light_r1, false);

gpu_set_blendmode(bm_normal);
draw_set_alpha(1);

if (vignette_alpha > 0) {
    draw_set_alpha(vignette_alpha);
    draw_set_color(c_black);

    // top/bottom bars
    draw_rectangle(0, 0, gw, 40, false);
    draw_rectangle(0, gh - 40, gw, gh, false);

    // left/right bars
    draw_rectangle(0, 0, 40, gh, false);
    draw_rectangle(gw - 40, 0, gw, gh, false);

    draw_set_alpha(1);
}
