// Breeze noise seeds
wind_t = irandom(999999);
flutter_t = irandom(999999);

// Current wind state (smoothed)
wind = 0;        // -1..1
wind_target = 0;

// Tuning
wind_change = 0.008;   // how fast wind evolves
wind_smooth = 0.04;    // how quickly it eases to target

sway_max = 45;         // degrees (overall lean)
flutter_max = 6;       // degrees (quick jitter)

sag_max = 45;          // degrees downward droop when calm
sag_smooth = 0.06;     // how fast sag changes

sag = 0;               // current sag angle

// Optional: subtle scale “flap”
scale_y = 1;

// Wave tuning
wave_amp   = 6;     // max pixels of vertical displacement (at far right)
wave_freq  = 0.10;  // how tight the waves are (higher = more ripples)
wave_speed = 0.10;  // how fast it moves

strip_w    = 2;     // width of each vertical slice (1–4). 1 = best, more cost
