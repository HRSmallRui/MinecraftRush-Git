extends ShooterBullet

@export var potion_area_scene: PackedScene


func _on_free_timer_timeout() -> void:
	super()
	summon_potion_area()
	pass


func enemy_take_damage(enemy: Enemy):
	super(enemy)
	summon_potion_area()
	pass


func summon_potion_area():
	var potion_area: SkillConditionArea2D = potion_area_scene.instantiate()
	potion_area.skill_level = bullet_special_tag_levels["plugin"]
	potion_area.position = position
	Stage.instance.bullets.add_child(potion_area)
	pass
