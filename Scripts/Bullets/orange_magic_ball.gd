extends MagicBall

@export var liquid_scene: PackedScene

var has_summon_liquid: bool = false


func _ready() -> void:
	super()
	free_timer.wait_time = 0.4
	free_timer.start()
	pass


func enemy_take_damage(enemy: Enemy):
	super(enemy)
	if bullet_special_tag_levels["fly"]: return
	summon_liquid(enemy.position)
	has_summon_liquid = true
	pass


func hit_effect():
	super()
	if !has_summon_liquid and !bullet_special_tag_levels["fly"]:
		summon_liquid(position + Vector2(0,10))
		has_summon_liquid = true
	pass


func summon_liquid(liquid_pos: Vector2):
	var alchemist_liquid: SkillConditionArea2D = liquid_scene.instantiate()
	alchemist_liquid.position = liquid_pos
	alchemist_liquid.skill_level = special_skill_level
	Stage.instance.bullets.add_child(alchemist_liquid)
	pass
