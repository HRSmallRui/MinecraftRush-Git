extends SkillButton

@export var undead_knight_scene: PackedScene

var level: int


func _ready() -> void:
	super()
	level = Stage.instance.get_hero_skill_level(7)
	pass


func skill_unlease():
	super()
	var undead_knight: SummonAlly = undead_knight_scene.instantiate()
	undead_knight.position = Stage.instance.get_local_mouse_position()
	undead_knight.level = level+1
	Stage.instance.allys.add_child(undead_knight)
	pass
