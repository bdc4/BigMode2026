
swing_vel += choose(-1, 1) * swing_force;
explode_sprite_pixels(sPizzaSplatter, 0, other.x, other.y, 1);
instance_destroy(other.id);

audio_play_sound_at(sndBell,x,y,0,400,800,1,false,2,1,0,1+random(1))

oPlayer.money += 1;