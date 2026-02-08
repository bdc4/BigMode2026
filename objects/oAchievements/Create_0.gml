/// oAchievement : Create
persistent = true;

// prevent duplicates
if (instance_number(object_index) > 1) { instance_destroy(); exit; }

// -------------------------
// Achievement definitions
// -------------------------
// Store by key string -> struct
ach = ds_map_create();

// Helper to define one achievement
function ach_add(_key, _spr, _title, _desc, _goal)
{
    var s = {
        key: _key,
        spr: _spr,
        title: _title,
        desc: _desc,
        goal: _goal,
        progress: 0,
        unlocked: false
    };
    ds_map_add(ach, _key, s);
}

// Example achievements (replace with yours)
//ach_add("fix_5",   sWrench, "Handyman", "Repair 5 objects.", 5);
ach_add("bib", sPizza, "Backwards is Best", "Deliver a Pizza while in Reverse.", 1);
ach_add("cook", sPizza, "We Need to Cook...", "Throw a Pizza on Walter's House.", 1);
ach_add("bell", sSchoolBell, "Pizza Bell", "Ring the school bell.", 1);
ach_add("bby", sCarPoliceRight, "Not even close, baby", "Outrun the Police for 60 Seconds", 1);
ach_add("rts", sPizzaDogPortrait, "Return to Sender","\"Return\" a Pizza to Pizza Dog.", 1);

// -------------------------
// Popup queue + animation
// -------------------------
popup_q = ds_queue_create();

popup = noone; // current popup struct or noone
popup_t = 0;

popup_in  = room_speed * 0.25;
popup_hold= room_speed * 5.00;
popup_out = room_speed * 0.25;

ui_pad = 16;
ui_w = 380;
ui_h = 84;
ui_v_pad = 300;

// optional: sound
snd_unlock = sndAchievement;

/// achievement_add_progress(key, amount)
function achievement_add_progress(_key, _amt)
{
    var mgr = instance_find(oAchievement, 0);
    if (mgr == noone) return;

    if (!ds_map_exists(mgr.ach, _key)) return;

    var a = ds_map_find_value(mgr.ach, _key);
    if (a.unlocked) return;

    a.progress = clamp(a.progress + _amt, 0, a.goal);

    if (a.progress >= a.goal) {
        a.unlocked = true;
        // write back (important!)
        ds_map_replace(mgr.ach, _key, a);

        // queue popup
        mgr.queue_popup(a.spr, a.title, a.desc);
    } else {
        ds_map_replace(mgr.ach, _key, a);
    }
}


/// achievement_set_progress(key, value)
function achievement_set_progress(_key, _val)
{
    var mgr = instance_find(oAchievements, 0);
    if (mgr == noone) return;

    if (!ds_map_exists(mgr.ach, _key)) return;

    var a = ds_map_find_value(mgr.ach, _key);
    if (a.unlocked) return;

    a.progress = clamp(_val, 0, a.goal);

    if (a.progress >= a.goal) {
        a.unlocked = true;
        ds_map_replace(mgr.ach, _key, a);
        mgr.queue_popup(a.spr, a.title, a.desc);
    } else {
        ds_map_replace(mgr.ach, _key, a);
    }
}

/// inside oAchievement Create, after ds_queue_create:

function queue_popup(_spr, _title, _desc)
{
    var p = {
        spr: _spr,
        title: _title,
        desc: _desc
    };
    ds_queue_enqueue(popup_q, p);

    // if nothing is showing, start immediately
    if (popup == noone) {
        popup = ds_queue_dequeue(popup_q);
        popup_t = 0;

        if (snd_unlock != -1) audio_play_sound(snd_unlock, 1, false);
    }
}


playerHover = false;