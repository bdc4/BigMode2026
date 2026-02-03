/// oDialog : Create
// dialog state
active = false;
speaker = "";
text = "";
lines = [];
line_index = 0;

// layout (GUI space)
pad = 16;
box_h = 120;

// typewriter (optional)
use_typewriter = true;
chars_per_step = 2;
shown_chars = 0;

// input
advance_key = vk_space;

auto_advance_time = 90; // frames per line (90 = 1.5s at 60fps)
line_timer = 0;


function dialog_show(_speaker, _text)
{
    active = true;
    speaker = _speaker;
    text = _text;

    // Simple line split (manual wrap later if you want)
    lines = string_split(text, "\n");
    line_index = 0;

    shown_chars = 0;
}

function dialog_get()
{
    var d = instance_find(oDialog, 0);
    if (d == noone) {
        d = instance_create_layer(0, 0, "Instances", oDialog);
        d.depth = -100000; // draw on top if you ever use Draw (not needed for GUI)
    }
    return d;
}

// TESTING
var d = dialog_get();
with (d) dialog_show("Shopkeeper", "Hey! Watch the paint.\nNeed a delivery job?");

