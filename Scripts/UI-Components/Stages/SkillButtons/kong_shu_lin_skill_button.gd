extends SkillButton

@export var release_scene: PackedScene
@export var damage_per_count: IntSaver
@export var knife_count: IntSaver
@export var knife_damage_list: Array[IntSaver]

var skill_level: int


func _ready() -> void:
	super()
	skill_level = Global.get_hero_skill_level(5)
	pass


func skill_unlease():
	super()
	var summon_pos: Vector2 = Stage.instance.get_local_mouse_position()
	var release_area: SkillConditionArea2D = release_scene.instantiate()
	release_area.position = summon_pos
	release_area.skill_level = skill_level
	Stage.instance.bullets.add_child(release_area)
	pass
