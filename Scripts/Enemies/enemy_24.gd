extends Enemy

@onready var dirt_audio: AudioStreamPlayer = $DirtAudio


func anim_offset():
	match enemy_sprite.animation:
		"idle","attack":
			enemy_sprite.position = Vector2(-30,-90) if enemy_sprite.flip_h else Vector2(30,-90)
		"die":
			enemy_sprite.position = Vector2(45,-115) if enemy_sprite.flip_h else Vector2(-45,-115)
		"move_back":
			enemy_sprite.position = Vector2(10,-85) if enemy_sprite.flip_h else  Vector2(-10,-85)
		"move_front":
			enemy_sprite.position = Vector2(-5,-90) if enemy_sprite.flip_h else Vector2(5,-90)
		"move_normal":
			enemy_sprite.position = Vector2(-10,-90) if enemy_sprite.flip_h else Vector2(10,-90)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 14:
		cause_damage()
	if enemy_sprite.animation == "die" and enemy_sprite.frame == 13:
		create_tween().tween_property(self,"modulate:a",0,1)
	pass


func die_explosion_process():
	EffectManager.instance.play_block_effect(position,Vector2.ONE,Color(1,1,0.7,1))
	dirt_audio.play()
	pass
