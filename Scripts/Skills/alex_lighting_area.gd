extends SkillConditionArea2D

@export var dizness_buff_scene: PackedScene
@export var lightning_sheild_buff_scene: PackedScene
@export var lightning_damage_list: Array[int]


func _ready() -> void:
	EffectManager.instance.play_lightning_effect(position)
	EffectManager.instance.play_explosion_effect(position,Vector2.ONE,Color.WHITE,1)
	AudioManager.instance.play_explosion_audio()
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	var damage: int
	damage = lightning_damage_list[skill_level-1]
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		var dizness_debuff: PropertyBuff = dizness_buff_scene.instantiate()
		dizness_debuff.unit = enemy
		enemy.buffs.add_child(dizness_debuff)
		if "creeper" in enemy.get_groups():
			enemy.enemy_buff_tags["lightning"] = 1
			enemy.remove_from_group("creeper")
			enemy.add_new_buff_tag("lightning")
			var lightning_buff: PropertyBuff = lightning_sheild_buff_scene.instantiate()
			lightning_buff.unit = enemy
			enemy.buffs.add_child(lightning_buff)
			continue
		enemy.take_damage(damage,DataProcess.DamageType.TrueDamage,0,true)
	
	queue_free()
	pass
