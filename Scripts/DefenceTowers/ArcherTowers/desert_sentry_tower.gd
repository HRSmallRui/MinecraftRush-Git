extends ArcherTower
class_name DesertSentryTower

@export var DESERT_KILLER_SCENE: PackedScene
@export var desert_wolf_scene: PackedScene
@export_group("Skill1Data")
@export var killing_damage_list: Array[DamageBlock]
@export var killing_possible_list: Array[float]
@export_group("Skill2Data")
@export var wolf_damage_list: Array[int]
@export var wold_dizness_time: Array[float]

@onready var skill_1_timer: Timer = $Skill1Timer
@onready var desert_shooter: AnimatedSprite2D = $TowerSprite/DesertShooter
@onready var killing_area: Area2D = $KillingArea
@onready var skill_2_timer: Timer = $Skill2Timer

var skill1_is_releasing: bool = false


func fighting_process():
	if tower_skill_levels[1] > 0 and skill_2_timer.is_stopped() and killing_area.has_overlapping_bodies():
		skill_2_timer.start()
		skill_2_release()
	
	if skill1_is_releasing: return
	if killing_area.has_overlapping_bodies() and skill_1_timer.is_stopped() and tower_skill_levels[0] > 0 and !desert_shooter.is_playing():
		if get_skill_1_enemy() != null:
			skill_1_timer.start()
			skill1_release()
			return
	super()
	pass


func skill1_release():
	desert_shooter.hide()
	skill1_is_releasing = true
	var enemy_list: Array[Enemy]
	for body in killing_area.get_overlapping_bodies():
		enemy_list.append(body.owner)
	var locked_enemy: Enemy = get_highest_health_enemy(enemy_list)
	var desert_killer: DesertSentryKillingSkill = DESERT_KILLER_SCENE.instantiate()
	desert_killer.desert_sentry_tower = self
	var damage: int = killing_damage_list[tower_skill_levels[0]-1].get_damage()
	var killing_possible: float = killing_possible_list[tower_skill_levels[0]-1]
	desert_killer.killing_possibile = killing_possible
	desert_killer.skill_damage = damage
	desert_killer.killing_enemy = locked_enemy
	Stage.instance.bullets.add_child(desert_killer)
	pass


func get_highest_health_enemy(enemy_list: Array[Enemy]) -> Enemy:
	var back_enemy: Enemy = enemy_list[0]
	for enemy in enemy_list:
		if back_enemy.current_data.health < enemy.current_data.health:
			back_enemy = enemy
	
	return back_enemy
	pass


func skill_2_release():
	var enemy_list: Array[Enemy]
	for body in killing_area.get_overlapping_bodies():
		enemy_list.append(body.owner)
	var locked_enemy: Enemy = get_latest_enemy(enemy_list)
	var desert_wolf: DesertWolfSkill = desert_wolf_scene.instantiate()
	desert_wolf.sample_enemy = locked_enemy
	var damage: int = wolf_damage_list[tower_skill_levels[1]-1]
	var dizness_time: float = wold_dizness_time[tower_skill_levels[1]-1]
	desert_wolf.damage = damage
	desert_wolf.dizness_time = dizness_time
	Stage.instance.bullets.add_child(desert_wolf)
	pass


func get_latest_enemy(enemy_list: Array[Enemy]) -> Enemy:
	var back_enemy: Enemy = enemy_list[0]
	for enemy in enemy_list:
		if back_enemy.progress > enemy.progress:
			back_enemy = enemy
	
	return back_enemy
	pass


func get_skill_1_enemy() -> Enemy:
	var enemy_list: Array[Enemy]
	for body in killing_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		if !"special" in enemy.get_groups():
			enemy_list.append(enemy)
	if enemy_list.is_empty(): return null
	else:
		return get_highest_health_enemy(enemy_list)
	pass


func get_skill_2_enemy() -> Enemy:
	var enemy_list: Array[Enemy]
	for body in killing_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		if !"special" in enemy.get_groups():
			enemy_list.append(enemy)
	if enemy_list.is_empty(): return null
	else:
		return get_latest_enemy(enemy_list)
	pass
