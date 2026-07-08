extends SkillConditionArea2D

@export var slow_buff_scene: PackedScene
@export var slow_duration_list: Array[float]
@export var wind_damage_list: Array[int]

@onready var wind_hit_particle: GPUParticles2D = $WindHitParticle
@onready var attack_audio: AudioStreamPlayer = $AttackAudio
@onready var finish_audio: AudioStreamPlayer = $FinishAudio


func _ready() -> void:
	wind_animation()
	await get_tree().physics_frame
	await get_tree().physics_frame
	var damage: int = wind_damage_list[skill_level]
	var slow_duration :float = slow_duration_list[skill_level]
	for i in 10:
		attack_audio.play()
		for body in get_overlapping_bodies():
			var enemy:Enemy = body.owner
			enemy.take_damage(damage,DataProcess.DamageType.TrueDamage,0,false,null,false,true)
			if enemy.enemy_type >= Enemy.EnemyType.MiniBoss: continue
			var slow_buff: PropertyBuff = slow_buff_scene.instantiate()
			slow_buff.duration = slow_duration
			enemy.buffs.add_child(slow_buff)
			enemy.start_data.armor = 0
			enemy.current_data.update_armor()
		await get_tree().create_timer(0.05,false).timeout
	
	await get_tree().create_timer(2,false).timeout
	finish_audio.play()
	create_tween().tween_property(self,"modulate:a",0,0.2)
	EffectManager.instance.play_explosion_effect(position,Vector2.ONE*4)
	EffectManager.instance.play_block_effect(position,Vector2.ONE*2,Color.GREEN)
	for i in 20:
		var summon_pos: Vector2 = position + Vector2(randf_range(-150,150),randf_range(-120,120))
		EffectManager.instance.play_block_effect(summon_pos,Vector2.ONE,Color.GREEN)
	
	await get_tree().create_timer(2,false).timeout
	queue_free()
	pass


func wind_animation():
	wind_hit_particle.emitting = true
	await get_tree().create_timer(0.5,false).timeout
	wind_hit_particle.emitting = false
	pass
