/// oRepairTruck : Create

// =========================
// SPRITES
// =========================
spr_right = sCarRepairRight;
spr_left  = sCarRepairLeft;
spr_up    = sCarRepairUpSizeAdjusted;
spr_down  = sCarRepairDownSizeAdjusted;

// =========================
// HOME / STATE
// =========================
home_x = x;
home_y = y;

state = 0; // 0=FIND, 1=TRAVEL, 2=REPAIR

// =========================
// TARGETING / PATHING
// =========================
target_id = noone;

retarget_cd      = 0;
path_recalc_cd   = 0;        // if you use this elsewhere
repath_cooldown  = 0;

grid_cell = 64;              // nav cell size
grid_pad  = 32;               // padding around buildings when marking blocked (px)

path_x = [];
path_y = [];
path_i = 0;

// =========================
// MOVEMENT (zippy but controllable)
// =========================
move_accel  = 0.25;          // higher = snappier
max_speed   = 6.5;
drag        = 0.06;
turn_rate   = 6;             // deg/step

slow_radius   = 64;
arrive_radius = 10;

hsp = 0;
vsp = 0;

// =========================
// PARKING
// =========================
park_dist = 32;              // distance below breakable bottom
park_x = x;
park_y = y;
has_park = false;

// =========================
// REPAIR
// =========================
repair_time = room_speed * 2; // 2 seconds
repair_t    = 0;              // 0..repair_time

// =========================
// VISUAL
// =========================
facing_angle = 0;             // used by pick_sprite_8dir_fake()
turn_smooth  = 0.35;          // optional: if you still use smoothing elsewhere

debug_draw_path = false;

start_x = x;
start_y = y;

audio_play_sound_at(sndCarRepairDrivingLOOP,x,y,0,150,600,1,true,1)