extends Enemy

@onready var explosion_area: Area2D = $UnitBody/ExplosionArea
@onready var shoot_audio: AudioStreamPlayer = $ShootAudio

var explosion_damage: int = 140


func anim_offset():
	match enemy_sprite.animation:
		"idle","attack":
			enemy_sprite.position = Vector2(-20,-75) if enemy_sprite.flip_h else Vector2(25,-75)
		"far_attack":
			enemy_sprite.position = Vector2(-15,-75) if enemy_sprite.flip_h else Vector2(15,-75)
		"move_back","move_front":
			enemy_sprite.position = Vector2(0,-70)
		"move_normal":
			enemy_sprite.position = Vector2(0,-75)
	pass


func add_new_buff_tag(tag_name: String, tag_level: int = 1):
	if tag_name == "lightning":
		explosion_area.scale = Vector2(2,2)
		explosion_damage  = 280
		remove_from_group("creeper")
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 9:
		cause_damage()
	if enemy_sprite.animation == "far_attack" and enemy_sprite.frame == 19:
		var summon_pos: Vector2 = far_attack_marker_flip.global_position if enemy_sprite.flip_h else far_attack_marker.global_position
		var damage: int = randi_range(current_data.far_damage_low,current_data.far_damage_high)
		var bullet: Bullet = summon_bullet(far_attack_bullet_scene,summon_pos,far_attack_position,damage,DataProcess.DamageType.TrueDamage)
		Stage.instance.bullets.add_child(bullet)
		shoot_audio.play()
	pass


func die(explosion: bool = false):
	explosion()
	super(false)
	hide()
	pass


func explosion():
	AudioManager.instance.play_explosion_audio()
	EffectManager.instance.play_explosion_effect(hurt_box.global_position)
	
	for ally_body: UnitBody in explosion_area.get_overlapping_bodies():
		var ally: Ally = ally_body.owner
		ally.take_damage(explosion_damage,DataProcess.DamageType.ExplodeDamage,0,false,self,false,true)
	pass
