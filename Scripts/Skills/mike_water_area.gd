extends SkillConditionArea2D

@export var broken_buff_scene: PackedScene
@export var water_damage_list: Array[int]
@export var enemy_debuff_damage_list: Array[DamageBlock]
@export var water_buff_duration_list: Array[float]

@onready var mike_water_effect: Sprite2D = $MikeWaterEffect


func _ready() -> void:
	water_animation()
	var damage: int = water_damage_list[skill_level]
	var during_time: float = water_buff_duration_list[skill_level]
	var damage_low: int = enemy_debuff_damage_list[skill_level].damage_low
	var damage_high: int = enemy_debuff_damage_list[skill_level].damage_high
	mike_water_effect.modulate.a = 0
	var appear_tween: Tween = create_tween()
	appear_tween.tween_property(mike_water_effect,"modulate:a",0.5,0.3)
	await appear_tween.finished
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		enemy.take_damage(damage,DataProcess.DamageType.SuperDamage,0,)
		if enemy.enemy_type < Enemy.EnemyType.MiniBoss:
			enemy.start_data.near_damage_low = mini(enemy.start_data.near_damage_low,damage_low)
			enemy.start_data.near_damage_high = mini(enemy.start_data.near_damage_high,damage_high)
			enemy.current_data.update_near_damage()
		var broken_buff: PropertyBuff = broken_buff_scene.instantiate()
		broken_buff.duration = during_time
		enemy.buffs.add_child(broken_buff)
		enemy.silence_layers += 1
	await get_tree().create_timer(0.5,false).timeout
	create_tween().tween_property(mike_water_effect,"modulate:a",0,1)
	await get_tree().create_timer(2,false).timeout
	queue_free()
	pass


func water_animation():
	for i in 10:
		var summon_pos: Vector2 = position + Vector2(randf_range(-120,120),randf_range(-80,80))
		EffectManager.instance.play_block_effect(summon_pos,Vector2.ONE*2,Color.ROYAL_BLUE)
		AudioManager.instance.play_water_audio()
		await get_tree().create_timer(randf_range(0.1,0.2),false).timeout
	pass
