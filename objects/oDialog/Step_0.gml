/// oDialog : Step
if (!active) exit;

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
        }
    }
} else {
    // still typing, don't count yet
    line_timer = 0;
}
