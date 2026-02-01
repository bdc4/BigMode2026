x += dx;
y += dy;

life -= 1;
image_alpha = life / 28;   // fade out
image_xscale += 0.02;
image_yscale += 0.02;

if (life <= 0) instance_destroy();
