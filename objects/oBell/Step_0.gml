// Gravity pulls bell back toward center
swing_vel -= swing_angle * swing_grav;

// Integrate velocity
swing_angle += swing_vel;

// Damping (air resistance / hinge friction)
swing_vel *= swing_damp;

// Clamp extreme swings
swing_angle = clamp(swing_angle, -max_swing, max_swing);

// Apply to sprite
image_angle = swing_angle;

// ------------------------------------------------------------
// Tongue follows opposite of bell swing with lag
// ------------------------------------------------------------

// Desired tongue angle is opposite bell swing (scaled down)
var target = -swing_angle * 0.6;

// Spring toward target
tongue_vel += (target - tongue_angle) * tongue_follow;

// Damping
tongue_vel *= tongue_damp;

// Integrate
tongue_angle += tongue_vel;

// Clamp
tongue_angle = clamp(tongue_angle, -tongue_max, tongue_max);

