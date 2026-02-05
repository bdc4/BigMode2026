function pizza_explode(_x, _y, _power)
{
    var ps = global.ps_pizza;
    if (ps == noone) exit;

    // power scales how many pixels
    var cheese_n = irandom_range(22, 34) + round(_power * 10);
    var pep_n    = irandom_range(14, 22) + round(_power * 7);
    var crust_n  = irandom_range(10, 16) + round(_power * 5);

    // Burst exactly at point
    part_particles_create(ps, _x, _y, global.pt_cheese_px, cheese_n);
    part_particles_create(ps, _x, _y, global.pt_pep_px,    pep_n);
    part_particles_create(ps, _x, _y, global.pt_crust_px,  crust_n);

    // Optional: a second burst slightly offset for a more “splat” look
    var ox = irandom_range(-3, 3);
    var oy = irandom_range(-3, 3);
    part_particles_create(ps, _x + ox, _y + oy, global.pt_cheese_px, round(cheese_n * 0.4));
}
