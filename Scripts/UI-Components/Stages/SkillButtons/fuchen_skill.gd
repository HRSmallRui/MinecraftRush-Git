extends SkillButton

@export var ray_scene: PackedScene
@export var ray_count_list: Array[int]


func skill_unlease_condition():
	if (Stage.instance.mouse_in_path or Stage.instance.mouse_in_fire_extra_area) and !Stage.instance.mouse_in_fire_stop_area:
		skill_unlease()
	pass


func skill_unlease():
	super()
	var level: int = Stage.instance.get_hero_skill_level(1)
	var count: int = ray_count_list[level]
	var mouse_position: Vector2 = Stage.instance.get_local_mouse_position()
	for i in count:
		await get_tree().create_timer(0.2,false).timeout
		var ray: Area2D = ray_scene.instantiate()
		ray.position = random_position(mouse_position)
		Stage.instance.bullets.add_child(ray)
	pass


func random_position(center_pos: Vector2) -> Vector2:
	return center_pos + Vector2(randf_range(-50,50),randf_range(-50,50))
	pass
