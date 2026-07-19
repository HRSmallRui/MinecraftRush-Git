extends SkillConditionArea2D

@export var dizness_buff_scene: PackedScene
@export var damage_list: Array[DamageBlock]
@export var dizness_time_list: Array[FloatSaver]


func _ready() -> void:
	var damage_block: DamageBlock = damage_list[skill_level-1]
	var dizness_time: float = dizness_time_list[skill_level-1].saving_float_value
	
	EffectManager.instance.play_block_effect(position,Vector2.ONE,Color(0.27,0.1,0,1))
	await get_tree().physics_frame
	await get_tree().physics_frame
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		
		var dizness_buff: BuffClass = dizness_buff_scene.instantiate()
		dizness_buff.duration = dizness_time
		enemy.buffs.add_child(dizness_buff)
		var damage: int = damage_block.get_damage()
		enemy.take_damage(damage,DataProcess.DamageType.ExplodeDamage,0,false,null,true,true,)
	pass
