function dialog_get()
{
    var d = instance_find(oDialog, 0);
    if (d == noone) {
        d = instance_create_layer(0, 0, "Instances", oDialog);
        d.depth = -100000; // draw on top if you ever use Draw (not needed for GUI)
    }
    return d;
}

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