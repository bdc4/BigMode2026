/// scr_pick_new_target()
/// Picks a new target building from global.buildings (excluding deactivated ones).

function scrPickNewTarget()
{
    if (!variable_global_exists("buildings")) return;
    if (ds_list_size(global.buildings) <= 0) return;

    // Clear old target (if any)
    if (instance_exists(global.target_building)) {
        global.target_building.is_target = false;
        global.target_building.image_blend = c_white;
    }

    // Collect candidates
    var candidates = ds_list_create();

    var n = ds_list_size(global.buildings);
    for (var i = 0; i < n; i++) {
        var b = global.buildings[| i];
        if (instance_exists(b) && !b.deactivated) {
            ds_list_add(candidates, b);
        }
    }

    if (ds_list_size(candidates) == 0) {
        global.target_building = noone;
        ds_list_destroy(candidates);
        return;
    }

    // Pick one
    var pick = candidates[| irandom(ds_list_size(candidates) - 1) ];
    global.target_building = pick;

    pick.is_target = true;
    pick.image_blend = c_red;

    ds_list_destroy(candidates);
}
