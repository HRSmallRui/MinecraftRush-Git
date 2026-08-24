extends SkillButton

@export var buff_potion_scene: PackedScene
@export var debuff_potion_scene: PackedScene
@export var potion_count_list: Array[int]


func skill_unlease():
	super()
	var level: int = Stage.instance.get_hero_skill_level(0)
	var count: int = potion_count_list[level]
	var mouse_position: Vector2 = Stage.instance.get_local_mouse_position()
	for i in count:
		var buff_potion: Area2D = buff_potion_scene.instantiate()
		var debuff_potion: Area2D = debuff_potion_scene.instantiate()
		buff_potion.position = random_position(mouse_position)
		debuff_potion.position = random_position(mouse_position)
		Stage.instance.bullets.add_child(buff_potion)
		await get_tree().create_timer(0.2,false).timeout
		Stage.instance.bullets.add_child(debuff_potion)
		await get_tree().create_timer(0.2,false).timeout
	pass


func random_position(center_pos: Vector2) -> Vector2:
	return center_pos + Vector2(randf_range(-25,25),randf_range(-18,18))
	pass
