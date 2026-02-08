// Swing state
swing_angle = 0;        // current visual angle
swing_vel   = 0;        // angular velocity

// Tuning
swing_force = 8;        // impulse when hit
swing_damp  = 0.88;     // energy loss per step (0.85–0.98)
swing_grav  = 0.25;     // pull back toward center
max_swing   = 35;       // clamp angle (degrees)

// Tongue (clapper) swing state
tongue_angle = 0;
tongue_vel   = 0;

// Tuning
tongue_follow = 0.25;   // how strongly it reacts to bell motion
tongue_damp   = 0.85;   // how quickly it settles
tongue_max    = 30;     // max tongue swing (degrees)

event_inherited()


bell_timer = 0;
bell_counter = 0;