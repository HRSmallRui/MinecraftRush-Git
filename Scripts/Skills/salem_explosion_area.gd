extends SkillConditionArea2D

@export var plague_buff_scene: PackedScene
@export var damage_list: Array[DamageBlock]

var dead_explosion_level: int
var passive_level: int


func _ready() -> void:
	var damage_block: DamageBlock = damage_list[skill_level-1]
	EffectManager.instance.play_explosion_effect(position,Vector2.ONE*1.5,Color.DARK_GREEN)
	EffectManager.instance.play_smoke_effect(position,Vector2.ONE*2,Color.GREEN)
	AudioManager.instance.play_explosion_audio()
	await get_tree().physics_frame
	await get_tree().physics_frame
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		var damage: int = damage_block.get_damage()
		enemy.take_damage(damage,DataProcess.DamageType.MagicDamage,0,false,null,false,true,)
		for i in 3:
			var plugin_buff: DotBuff = plague_buff_scene.instantiate()
			plugin_buff.dead_explosion_level = dead_explosion_level
			plugin_buff.passive_level = passive_level
			enemy.buffs.add_child(plugin_buff)
	
	await get_tree().create_timer(1,false).timeout
	queue_free()
	pass
