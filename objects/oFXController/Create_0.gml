/// oFXController : Create (run once)
if (!variable_global_exists("ps_pizza")) {
    global.ps_pizza = part_system_create();
    part_system_depth(global.ps_pizza, -10000);

    // Chunk tuning (pixel splatter look)
    // If your game is 2x/3x scaled, bump these up (e.g., 3..6)
    var chunk_min = .1;
    var chunk_max = .2;

    // --- CHEESE CHUNKS ---
    global.pt_cheese_px = part_type_create();
    part_type_shape(global.pt_cheese_px, pt_shape_square);          // chunkier than pt_shape_pixel
    part_type_size(global.pt_cheese_px, chunk_min, chunk_max, 0, 0);
    part_type_speed(global.pt_cheese_px, 2.5, 7.5, 0, 0);
    part_type_direction(global.pt_cheese_px, 0, 360, 0, 0);
    part_type_gravity(global.pt_cheese_px, 0.30, 270);
    part_type_life(global.pt_cheese_px, 12, 22);
    part_type_alpha2(global.pt_cheese_px, 1, 0);
    part_type_colour1(global.pt_cheese_px, make_color_rgb(255, 220, 70));
    part_type_blend(global.pt_cheese_px, false);                    // crunchy pixels

    // --- PEPPERONI CHUNKS (red) ---
    global.pt_pep_px = part_type_create();
    part_type_shape(global.pt_pep_px, pt_shape_square);
    part_type_size(global.pt_pep_px, chunk_min, chunk_max + 1, 0, 0); // slightly bigger on average
    part_type_speed(global.pt_pep_px, 2.0, 6.5, 0, 0);
    part_type_direction(global.pt_pep_px, 0, 360, 0, 0);
    part_type_gravity(global.pt_pep_px, 0.32, 270);
    part_type_life(global.pt_pep_px, 12, 24);
    part_type_alpha2(global.pt_pep_px, 1, 0);
    part_type_colour2(global.pt_pep_px, make_color_rgb(190, 40, 35), make_color_rgb(120, 20, 20));
    part_type_blend(global.pt_pep_px, false);

    // --- CRUST CHUNKS (brown) ---
    global.pt_crust_px = part_type_create();
    part_type_shape(global.pt_crust_px, pt_shape_square);
    part_type_size(global.pt_crust_px, chunk_min, chunk_max, 0, 0);
    part_type_speed(global.pt_crust_px, 1.5, 5.5, 0, 0);
    part_type_direction(global.pt_crust_px, 0, 360, 0, 0);
    part_type_gravity(global.pt_crust_px, 0.28, 270);
    part_type_life(global.pt_crust_px, 10, 20);
    part_type_alpha2(global.pt_crust_px, 1, 0);
    part_type_colour2(global.pt_crust_px, make_color_rgb(210, 160, 90), make_color_rgb(130, 90, 40));
    part_type_blend(global.pt_crust_px, false);
}
