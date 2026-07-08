extends SkillConditionArea2D

@export var lightning_sheild_buff_scene: PackedScene
@export var lightning_damage: DamageBlock


func _ready() -> void:
	EffectManager.instance.play_lightning_effect(position,Vector2.ONE if randf()<0.5 else -Vector2.ONE)
	EffectManager.instance.play_explosion_effect(position)
	AudioManager.instance.play_explosion_audio()
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		if "creeper" in enemy.get_groups():
			enemy.enemy_buff_tags["lightning"] = 1
			enemy.remove_from_group("creeper")
			enemy.add_new_buff_tag("lightning")
			var lightning_buff: PropertyBuff = lightning_sheild_buff_scene.instantiate()
			lightning_buff.unit = enemy
			enemy.buffs.add_child(lightning_buff)
			continue
		var damage: int = lightning_damage.get_damage()
		enemy.take_damage(damage,DataProcess.DamageType.TrueDamage,0,true)
	
	queue_free()
	pass
