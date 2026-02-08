/// oAchievement : Step
if (popup != noone)
{
    popup_t += 1;

    var total = popup_in + popup_hold + popup_out;
    if (popup_t >= total)
    {
        // next popup
        if (!ds_queue_empty(popup_q)) {
            popup = ds_queue_dequeue(popup_q);
            popup_t = 0;

            if (snd_unlock != -1) audio_play_sound(snd_unlock, 1, false);
        } else {
            popup = noone;
            popup_t = 0;
        }
    }
}
else
{
    // start if queued
    if (!ds_queue_empty(popup_q)) {
        popup = ds_queue_dequeue(popup_q);
        popup_t = 0;

        if (snd_unlock != -1) audio_play_sound(snd_unlock, 1, false);
    }
}


if (place_meeting(x,y,oPlayer)) {
	playerHover = true;
	show_debug_message("PLAYER HOVER")
} else {
	playerHover = false;
}