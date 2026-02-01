/// oWorldGen : Create
randomize();

var CELL = sprite_get_width(sBuildingMask);

// Grid dimensions in cells
gw = room_width div CELL;
gh = room_height div CELL;

global.buildings = ds_list_create();
global.target_building = noone;

// Occupancy grid: 0 = empty, 1 = occupied
occ = ds_grid_create(gw, gh);
ds_grid_clear(occ, 0);

// --- Tuning ---
var attempts = 800;           // higher = denser / more tries
var place_chance = 0.65;      // chance an attempt actually places something

var min_w = 4;                // building width in cells
var max_w = 16;
var min_h = 4;                // building height in cells
var max_h = 16;

var padding = 4;              // empty cells around buildings (0..2 feels good)

// Helper: check if rectangle is free (with padding)
function rect_is_free(x0, y0, w, h, pad)
{
    var ax0 = max(0, x0 - pad);
    var ay0 = max(0, y0 - pad);
    var ax1 = min(gw - 1, (x0 + w - 1) + pad);
    var ay1 = min(gh - 1, (y0 + h - 1) + pad);

    for (var yy = ay0; yy <= ay1; yy++)
    for (var xx = ax0; xx <= ax1; xx++)
    {
        if (occ[# xx, yy] == 1) return false;
    }
    return true;
}

// Helper: mark rectangle occupied (no padding)
function rect_fill(x0, y0, w, h)
{
    for (var yy = y0; yy < y0 + h; yy++)
    for (var xx = x0; xx < x0 + w; xx++)
    {
        occ[# xx, yy] = 1;
    }
}

for (var i = 0; i < attempts; i++)
{
    if (random(1) > place_chance) continue;

    // Random size in cells
    var bw = irandom_range(min_w, max_w);
    var bh = irandom_range(min_h, max_h);

    // Random top-left cell (stay in bounds)
    var cx = irandom(gw - bw);
    var cy = irandom(gh - bh);

    // Check overlap (+ padding)
    if (!rect_is_free(cx, cy, bw, bh, padding)) continue;

    // Mark occupied
    rect_fill(cx, cy, bw, bh);

    // Convert to pixels (top-left)
    var px = cx * CELL;
    var py = cy * CELL;

    // Create building
    var b = instance_create_layer(px, py, "Instances", oBuilding);

    // Store size (useful for collision, drawing, etc.)
    b.grid_w = bw;
    b.grid_h = bh;
    b.pixel_w = bw * CELL;
    b.pixel_h = bh * CELL;

    // If your sprite is 32x32 and origin is top-left, scaling is easy:
    b.image_xscale = bw;
    b.image_yscale = bh;
	
	ds_list_add(global.buildings, b);
}

// cleanup if you don't need it after generation
ds_grid_destroy(occ);

scrPickNewTarget();

