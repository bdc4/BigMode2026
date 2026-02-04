// movement
bullet_speed = 0;
life = 60;
speed_base = 4;
speed = speed_base;


// arc / height (pixels)
flight_time = life;   // total frames of the throw
t = 0;                // frames elapsed
z = 0;                // current height
max_z = 28;           // peak height (tune)

// optional: slight spin
spin_rate = 18;       // degrees per step
image_angle = irandom(359);

inherit_hsp = 0;
inherit_vsp = 0;
inherit_drag = 0.0; // set to 0.02..0.08 if you want the inherited momentum to fade
