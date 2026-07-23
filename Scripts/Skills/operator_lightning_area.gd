extends SkillConditionArea2D

@export var lightning_damage_list: Array[DamageBlock]
@export var lightning_dizness_duration_list: Array[FloatSaver]


func _ready() -> void:
	EffectManager.instance.play_lightning_effect(position)
	EffectManager.instance.play_explosion_effect(position)
	AudioManager.instance.play_explosion_audio()
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	var damage: int = lightning_damage_list[skill_level-1].get_damage()
	var dizness_time :float = lightning_dizness_duration_list[skill_level-1].saving_float_value
	
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		var dizness_debuff: PropertyBuff = preload("res://Scenes/Buffs/Alex/alex_dizness_debuff.tscn").instantiate()
		dizness_debuff.unit = enemy
		dizness_debuff.buff_tag = "OperatorDizness"
		dizness_debuff.duration = dizness_time
		enemy.buffs.add_child(dizness_debuff)
		if "creeper" in enemy.get_groups():
			enemy.enemy_buff_tags["lightning"] = 1
			enemy.remove_from_group("creeper")
			enemy.add_new_buff_tag("lightning")
			var lightning_buff: PropertyBuff = preload("res://Scenes/Buffs/lightning_sheild.tscn").instantiate()
			lightning_buff.unit = enemy
			enemy.buffs.add_child(lightning_buff)
			continue
		enemy.take_damage(damage,DataProcess.DamageType.TrueDamage,0,true)
	
	queue_free()
	pass
