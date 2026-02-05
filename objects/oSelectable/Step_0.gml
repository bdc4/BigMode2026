// Clear previous selection
with (oSelectable) selected = false;

// Find all selectables under cursor
var list = ds_list_create();

var n = collision_rectangle_list(
    oCursor.bbox_left, oCursor.bbox_top, oCursor.bbox_right, oCursor.bbox_bottom,
    oSelectable, false, false, list, false
);

if (n != noone && n > 0) {
    // Pick top-most by depth (lowest depth value draws on top)
    var top = list[| 0];

    for (var i = 1; i < n; i++) {
        var inst = list[| i];
        if (inst.depth < top.depth) {
            top = inst;
        }
    }

    top.selected = true;
}

ds_list_destroy(list);
