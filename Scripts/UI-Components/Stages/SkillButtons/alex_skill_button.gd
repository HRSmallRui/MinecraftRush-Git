extends SkillButton

@export var skill_area_scene: PackedScene

var level: int


func _ready() -> void:
	super()
	level = Global.get_hero_skill_level(2)
	pass


func skill_unlease():
	super()
	var skill_area: SkillConditionArea2D = skill_area_scene.instantiate()
	skill_area.skill_level = level
	skill_area.position = Stage.instance.get_local_mouse_position()
	Stage.instance.bullets.add_child(skill_area)
	pass
