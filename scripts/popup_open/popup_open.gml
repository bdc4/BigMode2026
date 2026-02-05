function popup_open(_target, _title, _options, _callbacks)
{
    // Only one popup at a time
    with (oPopupMenu) instance_destroy();

    var p = instance_create_layer(0, 0, "GUI", oPopupMenu);
    p.target = _target;
    p.title = _title;
    p.options = _options;
    p.callbacks = _callbacks;
    p.selected = 0;

    // Spawn near top-center by default
    p.x_gui = display_get_gui_width() * 0.5;
    p.y_gui = 60;

    return p;
}
