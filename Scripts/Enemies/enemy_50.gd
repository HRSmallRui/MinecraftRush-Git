extends Enemy

@export var poison_buff_scene: PackedScene


func anim_offset():
	match enemy_sprite.animation:
		"idle","attack":
			enemy_sprite.position = Vector2(0,-40)
		"die":
			enemy_sprite.position = Vector2(0,-45)
		"move_back":
			enemy_sprite.position = Vector2(0,-25)
		"move_front":
			enemy_sprite.position = Vector2(0,-30)
		"move_normal":
			enemy_sprite.position = Vector2(0,-35)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 12:
		cause_damage()
	pass


func on_normal_attack_hit(target_ally: Ally):
	var poison_buff: DotBuff = poison_buff_scene.instantiate()
	target_ally.buffs.add_child(poison_buff)
	pass
