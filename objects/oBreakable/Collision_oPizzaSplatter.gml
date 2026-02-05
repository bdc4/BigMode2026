if (id == other.target_id) {
	broken = true
	explode_sprite_pixels(sPizzaSplatter, 0, other.x, other.y, 1);
	instance_destroy(other.id)
}