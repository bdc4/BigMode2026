// Ensure we have a start position captured
if (!start_set) {
    x_start = x;
    y_start = y;
    start_set = true;
}

// Progress (0..1)
t += 1;
var p = clamp(t / flight_time, 0, 1);

// Straight-line flight that lands exactly on dest
x = lerp(x_start, dest_x, p);
y = lerp(y_start, dest_y, p);

// Arc height (optional)
z = sin(p * pi) * max_z;

// Optional spin
image_angle += spin_rate;

// Land exactly + trigger impact once
if (p >= 1) {
    x = dest_x;
    y = dest_y;
    event_user(0); // your impact/land logic
    exit;
}

// Lifetime safety (optional)
life -= 1;
if (life <= 0) event_user(0);
