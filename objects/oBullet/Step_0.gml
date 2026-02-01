// Move
x += lengthdir_x(bullet_speed, direction);
y += lengthdir_y(bullet_speed, direction);

// Lifetime / bounds
life -= 1;
if (life <= 0) instance_destroy();

if (x < -64 || y < -64 || x > room_width + 64 || y > room_height + 64) {
    instance_destroy();
}
