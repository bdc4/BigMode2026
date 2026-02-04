// Move in world (ground path)
x += lengthdir_x(bullet_speed, direction) + inherit_hsp;
y += lengthdir_y(bullet_speed, direction) + inherit_vsp;


// Flight progress (0..1)
t += 1;
var p = t / flight_time;
p = clamp(p, 0, 1);

// Smooth arc: 0 -> peak -> 0
// sin(pi*p) gives 0..1..0
z = sin(p * pi) * max_z;

// Optional spin
image_angle += spin_rate;

// Lifetime / bounds
life -= 1;
if (life <= 0) instance_destroy();

if (x < -64 || y < -64 || x > room_width + 64 || y > room_height + 64) {
    instance_destroy();
}
