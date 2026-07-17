extends Enemy

@export var heal_effect_scene: PackedScene

@onready var normal_attack_audio: AudioStreamPlayer = $NormalAttackAudio
@onready var light_sprite: Sprite2D = $UnitBody/LightSprite
@onready var heal_timer: Timer = $HealTimer
@onready var heal_area: Area2D = $UnitBody/HealArea


func anim_offset():
	match enemy_sprite.animation:
		"attack","idle":
			enemy_sprite.position = Vector2(5,-85) if enemy_sprite.flip_h else Vector2(-5,-85)
		"die":
			enemy_sprite.position = Vector2(0,-90) if enemy_sprite.flip_h else Vector2(5,-90)
		"far_attack":
			enemy_sprite.position = Vector2(15,-95) if enemy_sprite.flip_h else Vector2(-15,-95)
		"heal":
			enemy_sprite.position = Vector2(10,-85) if enemy_sprite.flip_h else Vector2(-10,-85)
		"move_back","move_front","move_normal":
			enemy_sprite.position = Vector2(0,-85)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 14 and !current_intercepting_units.is_empty():
		var ally: Ally = current_intercepting_units[0]
		normal_attack_audio.play()
		var damage: int = randi_range(current_data.near_damage_low,current_data.near_damage_high)
		ally.take_damage(damage,DataProcess.DamageType.MagicDamage,0,false,self,false,false,)
	if enemy_sprite.animation == "far_attack" and enemy_sprite.frame == 15:
		var summon_pos: Vector2 = far_attack_marker_flip.global_position if enemy_sprite.flip_h else far_attack_marker.global_position
		var damage: int = randi_range(current_data.far_damage_low,current_data.far_damage_high)
		var bullet: Bullet = summon_bullet(far_attack_bullet_scene,summon_pos,far_attack_position,damage,DataProcess.DamageType.MagicDamage)
		bullet.bullet_speed = 1500
		Stage.instance.bullets.add_child(bullet)
		AudioManager.instance.magic_shot_audio.play()
	pass


func die_blood() -> Sprite2D:
	light_sprite.hide()
	heal_timer.stop()
	return super()


func _on_heal_timer_timeout() -> void:
	if enemy_state == EnemyState.DIE:
		heal_timer.stop()
		return
	
	var heal_data: int = 120
	for body in heal_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		enemy.current_data.heal(heal_data)
		var heal_effect:BuffClass = heal_effect_scene.instantiate()
		enemy.buffs.add_child(heal_effect)
	pass # Replace with function body.
