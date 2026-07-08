extends SkillButton

@export var arrow_area_scene: PackedScene
@export var arrow_count_list: Array[int]

var level: int


func _ready() -> void:
	super()
	level = Global.get_hero_skill_level(10)
	pass


func skill_unlease():
	super()
	var offset_possible: float = 0.95
	var locked_enemy_path: EnemyPath = Stage.instance.get_closest_main_enemy_path(Stage.instance.get_local_mouse_position())
	var current_progress: float = locked_enemy_path.curve.get_closest_offset(Stage.instance.get_local_mouse_position())
	var arrow_count: int = arrow_count_list[level]
	var has_offseted: bool
	for i in arrow_count:
		var arrow_area: Area2D = arrow_area_scene.instantiate()
		arrow_area.position = locked_enemy_path.curve.sample_baked(current_progress)
		if randf() < offset_possible and !has_offseted:
			var v_offset: Vector2 = locked_enemy_path.curve.sample_baked_with_rotation(current_progress).y
			v_offset *= 25 if randf() < 0.5 else -25
			arrow_area.position += v_offset
			current_progress -= 2
			has_offseted = true
		else:
			has_offseted = false
			current_progress -= 4
		Stage.instance.bullets.add_child(arrow_area)
		AudioManager.instance.shoot_audio_1.play()
		await get_tree().create_timer(0.05,false).timeout
	pass
