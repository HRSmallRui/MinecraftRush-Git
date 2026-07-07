extends SkillConditionArea2D

@export var dizness_buff_scene: PackedScene


func _ready() -> void:
	var damage_low: int = HeroSkillLibrary.hero_skill_data_library[4][3].damage_low[skill_level-1]
	var damage_high: int = HeroSkillLibrary.hero_skill_data_library[4][3].damage_high[skill_level-1]
	var dizness_time: float = HeroSkillLibrary.hero_skill_data_library[4][3].dizness_time[skill_level-1]
	
	EffectManager.instance.play_block_effect(position,Vector2.ONE,Color(0.27,0.1,0,1))
	await get_tree().physics_frame
	await get_tree().physics_frame
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		
		var dizness_buff: BuffClass = dizness_buff_scene.instantiate()
		dizness_buff.duration = dizness_time
		enemy.buffs.add_child(dizness_buff)
		var damage: int = randi_range(damage_low,damage_high)
		enemy.take_damage(damage,DataProcess.DamageType.ExplodeDamage,0,false,null,true,true,)
	pass
