if (id == other.target_id && id != BB_ROOF.id) {
	broken = true
	if brokenSound audio_play_sound(brokenSound,1,false);
	explode_sprite_pixels(sPizzaSplatter, 0, other.x, other.y, 1);
	instance_destroy(other.id)
}

if (id == BB_ROOF.id) {
	oAchievements.achievement_set_progress("cook", 1)
}