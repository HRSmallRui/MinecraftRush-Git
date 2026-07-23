extends ArcherTower
class_name StoneTower

@export var extra_stone_damage_rate: FloatSaver

@onready var skill_1_timer: Timer = $Skill1Timer


func fighting_process():
	if skill_1_timer.is_stopped() and tower_skill_levels[0] > 0:
		normal_attack_timer.start()
		skill_1_timer.start()
		shooter_list[current_shooter_id].call_deferred("skill1_release")
		if current_shooter_id >= shooter_list.size() - 1: current_shooter_id = 0
		else: current_shooter_id += 1
		return
	super()
	pass
