// movement
bullet_speed = 12;
life = 60;

// arc / height (pixels)
flight_time = life;   // total frames of the throw
t = 0;                // frames elapsed
z = 0;                // current height
max_z = 28;           // peak height (tune)

// optional: slight spin
spin_rate = 18;       // degrees per step
image_angle = irandom(359);
