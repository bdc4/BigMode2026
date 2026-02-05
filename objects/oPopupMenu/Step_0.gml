if (!open) { instance_destroy(); exit; }

// Close if target is gone
if (close_if_target_gone && target != noone && !instance_exists(target)) {
    instance_destroy();
    exit;
}

// Keyboard navigation
if (keyboard_check_pressed(ord("W")))   selected = (selected - 1 + array_length(options)) mod array_length(options);
if (keyboard_check_pressed(ord("S"))) selected = (selected + 1) mod array_length(options);

// Close
if (keyboard_check_pressed(vk_escape)) {
    instance_destroy();
    exit;
}

// Activate
if (keyboard_check_pressed(vk_control)) {
    var cb = callbacks[selected];

    // cb can be a script/function reference, or [instance, script]
    if (is_array(cb)) {
        var inst = cb[0];
        var fn = cb[1];
        if (instance_exists(inst)) script_execute(fn, inst, target);
    } else {
        // function ref: fn(target)
        cb(target);
    }

    instance_destroy();
    exit;
}

// Mouse hover + click
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Compute rect for hit-testing
var lines = array_length(options);
var box_h = pad*2 + line_h*(lines + 1); // +1 for title
var x1 = x_gui - w*0.5;
var y1 = y_gui;
var x2 = x1 + w;
var y2 = y1 + box_h;

// If clicking outside, close
//if (mouse_check_button_pressed(mb_left)) {
//    if (!(mx >= x1 && mx <= x2 && my >= y1 && my <= y2)) {
//        instance_destroy();
//        exit;
//    }
//}

// Hover selection
for (var i = 0; i < lines; i++) {
    var ly1 = y1 + pad + line_h*(i+1);
    var ly2 = ly1 + line_h;
    if (mx >= x1 && mx <= x2 && my >= ly1 && my <= ly2) {
        selected = i;
        if (keyboard_check_pressed(vk_control)) {
            // activate same as Enter
            var cb2 = callbacks[selected];
            if (is_array(cb2)) {
                var inst2 = cb2[0];
                var fn2 = cb2[1];
                if (instance_exists(inst2)) script_execute(fn2, inst2, target);
            } else {
                cb2(target);
            }
            instance_destroy();
            exit;
        }
    }
}
