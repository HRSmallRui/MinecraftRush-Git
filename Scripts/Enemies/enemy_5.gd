extends Enemy


func anim_offset():
	match enemy_sprite.animation:
		"attack","idle":
			enemy_sprite.position = Vector2(0,-145)
		"die":
			enemy_sprite.position = Vector2(-70,-105) if enemy_sprite.flip_h else Vector2(70,-105)
		"move_normal":
			enemy_sprite.position = Vector2(5,-115) if enemy_sprite.flip_h else Vector2(-10,-115)
		"move_front","move_back":
			enemy_sprite.position = Vector2(0,-115) if enemy_sprite.flip_h else Vector2(-5,-115)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 19:
		cause_damage()
	pass


func die_blood() -> Sprite2D:
	var blood = super()
	blood.scale *= 1.5
	return blood
