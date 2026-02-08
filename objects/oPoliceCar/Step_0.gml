if (!audio_is_playing(sndCarRepairDrivingLOOP)) audio_play_sound_at(sndCarRepairDrivingLOOP,x,y,0,150,600,1,false,1)

if (spawn_timer == spawn_timer_max) {
	if (instance_number(oPoliceCar) < 12)
		instance_create_layer(start_x,start_y,layer,oPoliceCar)
	else {
		oPoliceCar.max_speed = 20;
	}
}
spawn_timer++;

if (alive_timer < room_speed * 20) {
	alive_timer++;
} else {
	oAchievements.achievement_set_progress("bby", 1)
}

// ------------------------------------------------------------
// Helpers
// ------------------------------------------------------------
function is_breakable_broken(_b)
{
    if (_b == noone) return false;
    if (!instance_exists(_b)) return false;

    if (variable_instance_exists(_b, "broken")) return _b.broken;
    if (variable_instance_exists(_b, "hp"))     return (_b.hp <= 0);
    return false;
}

function breakable_center(_b)
{
    var spr = _b.sprite_index;
    if (spr != -1) {
        var cx = (sprite_get_width(spr)  * 0.5) - sprite_get_xoffset(spr);
        var cy = (sprite_get_height(spr) * 0.5) - sprite_get_yoffset(spr);
        return [ _b.x + cx * _b.image_xscale, _b.y + cy * _b.image_yscale ];
    } else {
        return [ (_b.bbox_left + _b.bbox_right) * 0.5, (_b.bbox_top + _b.bbox_bottom) * 0.5 ];
    }
}

// Move toward a point with "arrive" steering (no wall collision here; path handles it)
function move_arrive(_tx, _ty)
{
    var distp = point_distance(x, y, _tx, _ty);
    var desired = point_direction(x, y, _tx, _ty);

    // turn toward desired (for sprite facing)
    var diff = angle_difference(desired, facing_angle);
    facing_angle += clamp(diff, -turn_rate, turn_rate);
    facing_angle = (facing_angle mod 360 + 360) mod 360;

    // arrive speed
    var desired_speed = max_speed;
    if (distp < slow_radius) desired_speed = max_speed * (distp / slow_radius);

    // velocity toward desired direction (straight to waypoint)
	var dvx = lengthdir_x(desired_speed, desired);
	var dvy = lengthdir_y(desired_speed, desired);


    hsp += (dvx - hsp) * move_accel;
    vsp += (dvy - vsp) * move_accel;

    // drag
    hsp *= (1 - drag);
    vsp *= (1 - drag);

    // clamp to desired_speed
    var vlen = point_distance(0, 0, hsp, vsp);
    var vmax = max(0.01, desired_speed);
    if (vlen > vmax) {
        var s = vmax / vlen;
        hsp *= s;
        vsp *= s;
        vlen = vmax;
    }

    // move
    x += hsp;
    y += vsp;

    return [distp, vlen];
}

function pick_nearest_broken()
{
    var best = noone;
    var best_d = 999999999;

    //with (oBreakable)
    //{
    //    if (other.is_breakable_broken(id))
    //    {
    //        var d = point_distance(x, y, other.x, other.y); // placeholder
    //        // (can't use other.x/other.y inside with like that)
    //    }
    //}

    // Do it without "with" to avoid older-GMS scoping pain:
    var inst = instance_find(oPlayer, 0);
    return inst;
}

function astar_path(_sx, _sy, _gx, _gy)
{
    // World -> cell
    var sx = floor(_sx / grid_cell);
    var sy = floor(_sy / grid_cell);
    var gx = floor(_gx / grid_cell);
    var gy = floor(_gy / grid_cell);

    if (sx == gx && sy == gy) return [[], []];

    // Bound search region
    var minx = min(sx, gx) - 6;
    var maxx = max(sx, gx) + 6;
    var miny = min(sy, gy) - 6;
    var maxy = max(sy, gy) + 6;

    minx = max(minx, 0);
    miny = max(miny, 0);
    maxx = min(maxx, ceil(room_width  / grid_cell));
    maxy = min(maxy, ceil(room_height / grid_cell));

    var w = maxx - minx + 1;
    var h = maxy - miny + 1;

    // Safety
    if (w <= 0 || h <= 0) return [[], []];

    var n = w * h;

    // Arrays
    var gCost  = array_create(n, 999999999);
    var fCost  = array_create(n, 999999999);
    var came   = array_create(n, -1);
    var open   = array_create(n, false);
    var closed = array_create(n, false);

    var openList = [];
    var openCount = 0;

    // Helpers inline
    // idx(cx,cy) = (cy-miny)*w + (cx-minx)
    var sI = (sy - miny) * w + (sx - minx);
    if (sI < 0 || sI >= n) return [[], []];

    gCost[sI] = 0;
    fCost[sI] = abs(sx - gx) + abs(sy - gy);
    open[sI] = true;
    openList[0] = sI;
    openCount = 1;

    var dxs = [1, -1, 0, 0];
    var dys = [0, 0, 1, -1];

    var found = false;
    var gI = -1;

    while (openCount > 0)
    {
        // best f
        var bestK = 0;
        var bestI = openList[0];
        var bestF = fCost[bestI];

        for (var k = 1; k < openCount; k++)
        {
            var ii = openList[k];
            var ff = fCost[ii];
            if (ff < bestF) { bestF = ff; bestI = ii; bestK = k; }
        }

        // pop
        openList[bestK] = openList[openCount - 1];
        openCount--;

        open[bestI] = false;
        closed[bestI] = true;

        // decode index -> cell
        var cy = floor(bestI / w) + miny;
        var cx = (bestI mod w) + minx;

        if (cx == gx && cy == gy) {
            found = true;
            gI = bestI;
            break;
        }

        for (var j = 0; j < 4; j++)
        {
            var nx = cx + dxs[j];
            var ny = cy + dys[j];

            // in bounds?
            if (nx < minx || nx > maxx || ny < miny || ny > maxy) continue;

            var ni = (ny - miny) * w + (nx - minx);
            if (closed[ni]) continue;

            // blocked at cell center?
            var wx = nx * grid_cell + grid_cell * 0.5;
            var wy = ny * grid_cell + grid_cell * 0.5;

            if (collision_point(wx, wy, oWall, false, false) != noone) continue;

            var tentative = gCost[bestI] + 1;

            if (!open[ni] || tentative < gCost[ni])
            {
                came[ni]  = bestI;
                gCost[ni] = tentative;
                fCost[ni] = tentative + abs(nx - gx) + abs(ny - gy);

                if (!open[ni]) {
                    open[ni] = true;
                    openList[openCount] = ni;
                    openCount++;
                }
            }
        }
    }

    if (!found) return [[], []];

    // Reconstruct
    var pxs = [];
    var pys = [];

    var cur = gI;
    while (cur != -1 && cur != sI)
    {
        var cy2 = floor(cur / w) + miny;
        var cx2 = (cur mod w) + minx;

        pxs[array_length(pxs)] = cx2 * grid_cell + grid_cell * 0.5;
        pys[array_length(pys)] = cy2 * grid_cell + grid_cell * 0.5;

        cur = came[cur];
    }

    // reverse
    var L = array_length(pxs);
    for (var a = 0; a < floor(L / 2); a++)
    {
        var b = L - 1 - a;

        var tx = pxs[a]; pxs[a] = pxs[b]; pxs[b] = tx;
        var ty = pys[a]; pys[a] = pys[b]; pys[b] = ty;
    }

    return [pxs, pys];
}


// ------------------------------------------------------------
// Validate target
// ------------------------------------------------------------
if (target_id != noone) {
    if (!instance_exists(target_id)) {
        target_id = noone;
        state = 0;
        has_park = false;
        repair_t = 0;
        path_x = [];
        path_y = [];
        path_i = 0;
    }
}

// cooldown for repathing (optional)
if (repath_cooldown > 0) repath_cooldown--;

// ------------------------------------------------------------
// STATE 0: FIND
// ------------------------------------------------------------
// build path to park point
        var p = astar_path(x, y, park_x, park_y);
        path_x = p[0];
        path_y = p[1];
        path_i = 0;

if (state == 0)
{
    target_id = pick_nearest_broken();

    if (target_id != noone)
    {
        // lock park point: bottom of breakable
        var c = breakable_center(target_id);
        var tx = c[0];

        var bbot = target_id.bbox_bottom;
        park_x = tx;
		var _pd = park_dist;
		if (target_id.object_index == oWindow) _pd += 80;
        park_y = bbot + _pd;

        has_park = true;

        // build path to park point
        p = astar_path(x, y, park_x, park_y);
        path_x = p[0];
        path_y = p[1];
        path_i = 0;

        state = 1; // TRAVEL
    }

    pick_sprite_8dir_fake(facing_angle);
    exit;
}

// ------------------------------------------------------------
// STATE 1: TRAVEL (follow path points)
// ------------------------------------------------------------
if (state == 1)
{
    if (!has_park) { state = 0; exit; }

    // If we have no path (failed), just go direct
    var tx = park_x;
    var ty = park_y;

    if (array_length(path_x) > 0 && path_i < array_length(path_x)) {
        tx = path_x[path_i];
        ty = path_y[path_i];

        // advance waypoint when close
        if (point_distance(x, y, tx, ty) < 32) path_i++;
    }

    var mv = move_arrive(tx, ty);
    var distp = point_distance(x, y, park_x, park_y);
    var vlen  = mv[1];

    // if we’re basically at the final park spot, enter REPAIR state
    if (distp <= arrive_radius && vlen < 0.8)
    {
        // stop cleanly
        hsp = 0; vsp = 0;
		
		if (target_id != noone) {
			state = 2;
			repair_t = 0;
		} else {
	        state = 0;
	        has_park = false;
	        repair_t = 0;
	        path_x = [];
	        path_y = [];
	        path_i = 0;
		}
    }

    // repath occasionally if stuck (optional)
	//if (repath_cooldown <= 0 && array_length(path_x) > 0 && path_i < array_length(path_x)) {
	//    // if the next node is blocked now, repath
	//    // (cheap check at node)
	//    if (collision_point(path_x[path_i], path_y[path_i], oWall, false, false) != noone) {
	//        var p2 = astar_path(x, y, park_x, park_y);
	//        path_x = p2[0];
	//        path_y = p2[1];
	//        path_i = 0;
	//        repath_cooldown = room_speed * 0.5;
	//    }
	//}

    pick_sprite_8dir_fake(facing_angle);
    exit;
}

// ------------------------------------------------------------
// STATE 2: REPAIR (parked)
// ------------------------------------------------------------
if (state == 2)
{
	state = 0;
	exit;
    // face the breakable while repairing (optional nice look)
    if (target_id != noone && instance_exists(target_id)) {
        //var bc = breakable_center(target_id);
        //var desired = point_direction(x, y, bc[0], bc[1]);
        //var diff2 = angle_difference(desired, facing_angle);
        //facing_angle += clamp(diff2, -turn_rate, turn_rate);
        //facing_angle = (facing_angle mod 360 + 360) mod 360;
    }
    repair_t += 1;

	if (!audio_is_playing(sndCarRepairFixObjects)) {
			audio_play_sound_at(sndCarRepairFixObjects,target_id.x,target_id.y,0,150,600,1,false,1)
	}
			
    if (repair_t >= repair_time)
    {
		
        // perform repair
        if (target_id != noone && instance_exists(target_id)) {
            with (target_id) {
                if (variable_instance_exists(id, "broken")) broken = false;
                if (variable_instance_exists(id, "hp"))     hp = max_hp;
                if (variable_instance_exists(id, "type"))   sprite_index = type;
            }
        }

        // clear repaired target
		target_id = noone;
		has_park  = false;
		repair_t  = 0;
		path_x = []; path_y = []; path_i = 0;

		// immediately check if there's another job
		var next_job = pick_nearest_broken();

		if (next_job != noone) {
		    state = 0; // FIND will lock park + path next step
		} else {
		    // go home
		    park_x = start_x;
		    park_y = start_y;
		    has_park = true;

		    var p = astar_path(x, y, park_x, park_y);
		    path_x = p[0];
		    path_y = p[1];
		    path_i = 0;

		    state = 1; // RETURN_HOME
		}

    }

    pick_sprite_8dir_fake(facing_angle);
    exit;
}