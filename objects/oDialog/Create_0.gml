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

auto_advance_time = 120; // frames per line (90 = 1.5s at 60fps)
line_timer = 0;

portrait_sprite = noone;
portrait_index  = 0;     // subimage
portrait_pad    = 10;
portrait_size   = 96;    // GUI pixels (square)

portrait_anim = true;
portrait_fps = 6;        // frames per second for the portrait
portrait_frame = 0;      // float so it can advance smoothly


function dialog_show(_speaker, _text, _portrait_sprite, _portrait_index)
{
    active = true;
    speaker = _speaker;
    text = _text;

    lines = string_split(text, "\n");
    line_index = 0;

    shown_chars = 0;
    line_timer = 0;

    portrait_sprite = _portrait_sprite;
    portrait_index  = _portrait_index;
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

alarm[0] = 1;


