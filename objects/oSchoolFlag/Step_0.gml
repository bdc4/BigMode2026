// --- Wind target evolves slowly (random breeze) ---
wind_t += 1;
if (random(1) < wind_change) {
    wind_target = random_range(-1, 1);
}

// Smooth wind toward target
wind = lerp(wind, wind_target, wind_smooth);

// --- Flutter (faster oscillation, stronger when wind is strong) ---
flutter_t += 1;
var gust = abs(wind);
var flutter = sin(flutter_t * 0.35) * flutter_max * gust;

// --- Sway (slow lean with wind) ---
var sway = wind * sway_max;

// --- Sag (droops more when wind is weak) ---
var sag_target = (1 - gust) * sag_max;
sag = lerp(sag, sag_target, sag_smooth);

// Final angle: lean with wind, add flutter, add sag downward
image_angle = sway + flutter + sag;

if !audio_is_playing(sndFlagLOOP) audio_play_sound_at(sndFlagLOOP,x,y,0,200,320,1,true,3)
// Optional: subtle “flap” squish
//scale_y = lerp(scale_y, 1 - 0.06 * sin(flutter_t * 0.55) * gust, 0.15);
