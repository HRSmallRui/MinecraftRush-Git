extends ShooterBullet

@export var lightning_area_scene: PackedScene

var summoned_lightning: bool


func _ready() -> void:
	super()
	move_finshed.connect(on_move_finished)
	pass


func enemy_take_damage(enemy: Enemy):
	super(enemy)
	if summoned_lightning:
		return
	summon_lightning(enemy.position)
	pass


func summon_lightning(summon_pos: Vector2):
	summoned_lightning = true
	var alex_lighting_area: SkillConditionArea2D = lightning_area_scene.instantiate()
	alex_lighting_area.skill_level = special_skill_level
	alex_lighting_area.position = summon_pos
	Stage.instance.add_child(alex_lighting_area)
	pass


func on_move_finished():
	if summoned_lightning:
		return
	summon_lightning(position)
	pass
