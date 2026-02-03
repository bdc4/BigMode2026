/// @func skid_update(_player, _turn, _vlen)
/// @desc Drop skid segments when turning at near max speed.
/// @param _player  instance id (usually self)
/// @param _turn    -1,0,1 (left/right input or steering direction)
/// @param _vlen    current speed magnitude (e.g., point_distance(0,0,hsp,vsp))

function skid_update(_player, _turn, _vlen)
{
    // --- Settings (read from player if present, else defaults) ---
    var max_speed     = _player.max_speed;
    var tip_off       = _player.tip_angle_offset;

    var skid_spacing  = variable_instance_exists(_player, "skid_spacing") ? _player.skid_spacing : 5;
    var wheel_offset  = variable_instance_exists(_player, "wheel_offset") ? _player.wheel_offset : 6;
    var skid_life     = variable_instance_exists(_player, "skid_life")    ? _player.skid_life    : 45;
    var skid_width    = variable_instance_exists(_player, "skid_width")   ? _player.skid_width   : 2;

    var back          = variable_instance_exists(_player, "wheel_back")   ? _player.wheel_back   : 6;

    // --- Conditions ---
   var at_max  = (_vlen >= max_speed * 0.65);
	var turning = (_turn != 0);

	// Keep skidding as long as the turn key is held (and we're fast)
	var skidding = at_max && turning;


    // --- Compute wheel positions ---
    var forward_dir = _player.facing + tip_off;
    var side_dir    = forward_dir + 90;

    var wL_x = _player.x + lengthdir_x(-back, forward_dir) + lengthdir_x(-wheel_offset, side_dir);
    var wL_y = _player.y + lengthdir_y(-back, forward_dir) + lengthdir_y(-wheel_offset, side_dir);

    var wR_x = _player.x + lengthdir_x(-back, forward_dir) + lengthdir_x( wheel_offset, side_dir);
    var wR_y = _player.y + lengthdir_y(-back, forward_dir) + lengthdir_y( wheel_offset, side_dir);

    // Ensure prev wheel positions exist
    if (!variable_instance_exists(_player, "prev_wL_x")) {
        _player.prev_wL_x = wL_x; _player.prev_wL_y = wL_y;
        _player.prev_wR_x = wR_x; _player.prev_wR_y = wR_y;
    }

    if (skidding) {
        if (point_distance(_player.prev_wL_x, _player.prev_wL_y, wL_x, wL_y) >= skid_spacing) {

            // Choose layer (player can override with decal_layer_name)
            var layer_name = variable_instance_exists(_player, "decal_layer_name") ? _player.decal_layer_name : layer_get_id(layer);

            // If they stored a string layer name, use it; else assume it's already a layer id
            var lay = is_string(layer_name) ? layer_name : layer;

            var segL = instance_create_layer(0, 0, lay, oSkidSeg);
            segL.x1 = _player.prev_wL_x; segL.y1 = _player.prev_wL_y;
            segL.x2 = wL_x;              segL.y2 = wL_y;
            segL.width = skid_width;
            segL.maxlife = skid_life;

            var segR = instance_create_layer(0, 0, lay, oSkidSeg);
            segR.x1 = _player.prev_wR_x; segR.y1 = _player.prev_wR_y;
            segR.x2 = wR_x;              segR.y2 = wR_y;
            segR.width = skid_width;
            segR.maxlife = skid_life;

            _player.prev_wL_x = wL_x; _player.prev_wL_y = wL_y;
            _player.prev_wR_x = wR_x; _player.prev_wR_y = wR_y;
        }
    } else {
        // Reset history so next skid starts clean
        _player.prev_wL_x = wL_x; _player.prev_wL_y = wL_y;
        _player.prev_wR_x = wR_x; _player.prev_wR_y = wR_y;
    }
}
