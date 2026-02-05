// Visuals
facing = 0;
visual_facing = 0;
turn_speed = 0.18;

// Velocity-based driving
hsp = 0;
vsp = 0;

engine_accel = 1.4;   // thrust per step while holding Space
max_speed    = 16.0;    // clamps total velocity magnitude
drag         = 0.08;   // general friction/air resistance
turn_rate    = 7;    // degrees per step

drag_base = drag;        // your existing drag value (e.g. 0.08)
drag_jitter = 0.02;      // +/- range (try 0.005 to 0.03)
drag_smooth = 0.10;      // 0..1, higher = quicker changes
drag_cur = drag_base;

bounce_loss = 1; // 1 = perfect bounce, 0.5 = very soft
min_bounce_speed = 0.2; // below this, stop bouncing
crash_timer = 0;
crash_lock_frames = 18; // tune: 6–14 feels good



// If your sprite points UP when image_angle=0 visually, set this to -90.
// If your sprite points RIGHT when image_angle=0, set this to 0.
tip_angle_offset = 0;

smoke_tick = -1;


// skid
skid_spacing = 5;
wheel_offset = 6;
wheel_back = 6;
skid_life = 45;
skid_width = 2;

// If you have a dedicated layer for marks:
decal_layer_name = "GroundDecals"; // create this layer in the room

// --- Camera ---
cam_id = view_camera[0]; // or however you stored your camera

base_view_w = camera_get_view_width(cam_id);
base_view_h = camera_get_view_height(cam_id);


// --- Camera zoom tuning ---
cam_zoom_in  = 1.0;   // normal zoom (1 = default)
cam_zoom_out = 1.5;   // zoom when at max speed (1.1–1.4 feels good)
cam_zoom_lerp = 0.08; // smoothing (0.05–0.15)

cam_zoom_cur = cam_zoom_in;

// Spin-out / crash state
spin_timer = 0;        // frames remaining in spin-out
spin_rate = 0;         // degrees per frame (signed)
spin_damp = 0.92;      // angular damping per step
spin_total = 0;        // accumulated degrees rotated this spin-out (abs)
spin_target = 0;       // degrees to rotate before ending
spin_time = 0;        // frames remaining
spin_time_max = 30;   // 60 frames ≈ 1 second at 60fps
spin_dir = 1;         // -1 or +1
spin_start_rate = 0;  // deg/frame at start

// drag
road_drag_extra = 0.12;  // additional drag when off-road
road_check_radius = 0;   // 0 = point check; try 8 for a small area
road_layer_id = layer_get_id("Driveable");
road_map_id = layer_tilemap_get_id(road_layer_id);

// Bullet charge
shoot_charging = false;
shoot_charge = 0;

shoot_charge_max = 12;

min_charge_frames = 8;
barely_speed = 1.2;

bullet_speed_min = 1;
bullet_speed_max = 8;
bullet_charge_pow = 1.6;

// resources
ammo = 0;
max_ammo = 1;


// Demo mode
demo_mode = true;

demo_path = PathDemo;
demo_speed = 13.5;          // world units per step
demo_pos = 0;              // 0..1 on path
demo_look = 0.015;         // aim ahead (0.01..0.04)
demo_turn_rate = 5;        // degrees per step
demo_throttle = 0.35;      // accel strength per step
demo_drag = 0.06;          // should match your drag feel
demo_snap = 0.10;          // how hard we "pull" back toward the path


