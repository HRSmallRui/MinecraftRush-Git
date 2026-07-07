extends SkillConditionArea2D

@export var lightning_random_texture_list: Array[Texture]
@export var damage_list: Array[DamageBlock]

@onready var lightning_sprite: Sprite2D = $LightningSprite


func _ready() -> void:
	lightning_sprite.texture = lightning_random_texture_list[randi_range(0,lightning_random_texture_list.size()-1)]
	disappear()
	var damage_block: DamageBlock = damage_list[skill_level-1]
	await get_tree().physics_frame
	await get_tree().physics_frame
	for hurt_box in get_overlapping_areas():
		var enemy: Enemy = hurt_box.owner
		var damage: int = damage_block.get_damage()
		enemy.take_damage(damage,DataProcess.DamageType.TrueDamage,0,false,null,false,true)
	pass


func _on_timer_timeout() -> void:
	var erase_texture: Texture = lightning_sprite.texture
	var random_list: Array[Texture] = lightning_random_texture_list.duplicate()
	random_list.erase(erase_texture)
	lightning_sprite.texture = random_list[randi_range(0,random_list.size()-1)]
	pass # Replace with function body.


func disappear():
	var disappear_tween: Tween = create_tween()
	disappear_tween.tween_property(lightning_sprite,"modulate:a",0,0.5)
	create_tween().tween_property(lightning_sprite,"scale",lightning_sprite.scale * 2, 0.5)
	await disappear_tween.finished
	queue_free()
	pass
