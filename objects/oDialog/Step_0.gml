/// oDialog : Step
if (!active) exit;

if (portrait_anim && portrait_sprite != noone) {
    var fc = sprite_get_number(portrait_sprite);
    if (fc > 1) {
        portrait_frame = (portrait_frame + (portrait_fps / room_speed)) mod fc;
        portrait_index = floor(portrait_frame);
    } else {
        portrait_index = 0;
        portrait_frame = 0;
    }
}


var cur = lines[line_index];

// -----------------------------
// TYPEWRITER
// -----------------------------
if (use_typewriter) {
    shown_chars = min(string_length(cur), shown_chars + chars_per_step);
} else {
    shown_chars = string_length(cur);
}

// -----------------------------
// AUTO-ADVANCE TIMER
// -----------------------------
if (shown_chars >= string_length(cur)) {
    // line fully visible, start counting
    line_timer += 1;

    if (line_timer >= auto_advance_time) {
        // move to next line
        line_index += 1;
        shown_chars = 0;
        line_timer = 0;

        // end dialog if no more lines
        if (line_index >= array_length(lines)) {
            active = false;
        } else {
			barks = 0;
			alarm[1] = 10;
		}
    }
} else {
    // still typing, don't count yet
    line_timer = 0;
}
