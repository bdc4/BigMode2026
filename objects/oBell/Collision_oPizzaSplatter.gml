
swing_vel += choose(-1, 1) * swing_force;
explode_sprite_pixels(sPizzaSplatter, 0, other.x, other.y, 1);
instance_destroy(other.id);
