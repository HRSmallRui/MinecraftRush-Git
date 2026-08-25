extends SkillButton

@export var johnny_area_scene: PackedScene
@export var existing_time_list: Array[FloatSaver]

var level: int


func _ready() -> void:
	super()
	level = Stage.instance.get_hero_skill_level(8)
	pass

func skill_unlease():
	super()
	var johnny_area: SkillConditionArea2D = johnny_area_scene.instantiate()
	johnny_area.position = Stage.instance.get_local_mouse_position()
	johnny_area.skill_level = level
	Stage.instance.bullets.add_child(johnny_area)
	pass
