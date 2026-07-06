extends Enemy

@onready var skeleton_audio: AudioStreamPlayer = $SkeletonAudio
@onready var skeleton_explosion_audio: AudioStreamPlayer = $SkeletonExplosionAudio


func anim_offset():
	match enemy_sprite.animation:
		"idle","attack":
			enemy_sprite.position = Vector2(-5,-115) if enemy_sprite.flip_h else Vector2(5,-115)
		"die":
			enemy_sprite.position = Vector2(55,-90) if enemy_sprite.flip_h else Vector2(-60,-90)
		"move_back":
			enemy_sprite.position = Vector2(0,-85)
		"move_front":
			enemy_sprite.position = Vector2(0,-90)
		"move_normal":
			enemy_sprite.position = Vector2(-5,-90) if enemy_sprite.flip_h else Vector2(5,-90)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 15:
		cause_damage()
	pass


func die(explosion: bool = false):
	super(explosion)
	if explosion:
		die_explosion_process()
	else:
		skeleton_audio.play()
	pass
