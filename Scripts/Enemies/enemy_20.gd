extends Enemy

@export var hunger_buff_scene: PackedScene


func anim_offset():
	match enemy_sprite.animation:
		"idle","attack":
			enemy_sprite.position = Vector2(-5,-120) if enemy_sprite.flip_h else Vector2(0,-120)
		"die":
			enemy_sprite.position = Vector2(55,-100) if enemy_sprite.flip_h else Vector2(-55,-100)
		"move_back":
			enemy_sprite.position = Vector2(0,-90)
		"move_front":
			enemy_sprite.position = Vector2(0,-95)
		"move_normal":
			enemy_sprite.position = Vector2(-15,-95) if enemy_sprite.flip_h else Vector2(15,-95)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 14:
		cause_damage()
	pass


func on_normal_attack_hit(target_ally: Ally):
	var hunger_buff: DotBuff = hunger_buff_scene.instantiate()
	hunger_buff.unit = current_intercepting_units[0]
	target_ally.buffs.add_child(hunger_buff)
	pass
