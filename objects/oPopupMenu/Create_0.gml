// Data
target = noone;          // instance this menu is for
title = "Interact";
options = [];            // array of strings
callbacks = [];          // array of [obj, script] OR script refs (see usage below)

// State
selected = 0;
open = true;

// Layout
pad = 10;
w = 220;
line_h = 18;

// Positioning (GUI space)
x_gui = display_get_gui_width() * 0.5;
y_gui = display_get_gui_height() * 0.5;

// Colors
bg_col = c_black;
fg_col = c_white;
hl_col = c_yellow;

// Optional: close if target disappears
close_if_target_gone = true;
