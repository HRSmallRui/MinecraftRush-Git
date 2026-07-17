extends Enemy


func anim_offset():
	match enemy_sprite.animation:
		"attack","idle":
			enemy_sprite.position = Vector2(5,-90) if enemy_sprite.flip_h else Vector2(-5,-90)
		"die":
			enemy_sprite.position = Vector2(85,-90) if enemy_sprite.flip_h else Vector2(-85,-90)
		"far_attack":
			enemy_sprite.position = Vector2(5,-90) if enemy_sprite.flip_h else Vector2(-5,-90)
		"move_back":
			enemy_sprite.position = Vector2(-5,-95) if enemy_sprite.flip_h else Vector2(5,-95)
		"move_front":
			enemy_sprite.position = Vector2(15,-95) if enemy_sprite.flip_h else Vector2(-15,-95)
		"move_normal":
			enemy_sprite.position = Vector2(0,-95)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 14:
		cause_damage()
	if enemy_sprite.animation == "far_attack" and enemy_sprite.frame == 20:
		var summon_pos: Vector2 = far_attack_marker_flip.global_position if enemy_sprite.flip_h else far_attack_marker.global_position
		var damage: int = randi_range(current_data.far_damage_low,current_data.far_damage_high)
		var bullet: Bullet = summon_bullet(far_attack_bullet_scene,summon_pos,far_attack_position,damage,DataProcess.DamageType.PhysicsDamage)
		bullet.bullet_speed = 1500
		Stage.instance.bullets.add_child(bullet)
		AudioManager.instance.shoot_audio_2.play()
	pass
