extends ShooterBullet

@export var lightning_area_scene: PackedScene


func enemy_take_damage(enemy: Enemy):
	super(enemy)
	var alex_lighting_area: SkillConditionArea2D = lightning_area_scene.instantiate()
	alex_lighting_area.skill_level = special_skill_level
	alex_lighting_area.position = enemy.position
	Stage.instance.add_child(alex_lighting_area)
	pass
