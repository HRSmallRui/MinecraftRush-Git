extends Enemy

@onready var move_audio: AudioStreamPlayer = $MoveAudio


func anim_offset():
	match enemy_sprite.animation:
		"attack","die","idle":
			enemy_sprite.position = Vector2(0,-20)
		"move_back","move_front","move_normal":
			enemy_sprite.position = Vector2(0,-65)
	pass


func frame_changed():
	if "move" in enemy_sprite.animation and enemy_sprite.frame == 27:
		move_audio.play()
	pass
