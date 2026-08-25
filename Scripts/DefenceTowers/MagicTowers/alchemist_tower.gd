extends MagicTower
class_name AlchemistTower

@export var liquid_damage_list: Array[IntSaver]
@export var liquid_property_block_list: Array[PropertyBuffBlock]

@onready var skill_1_timer: Timer = $Skill1Timer


func _ready() -> void:
	super()
	await get_tree().process_frame
	pass


func fighting_process():
	if tower_skill_levels[0] > 0 and skill_1_timer.is_stopped() and tower_area.has_overlapping_bodies() and normal_attack_timer.is_stopped():
		var skill1_enemy: Enemy = get_valid_skill1_enemy()
		#print(skill1_enemy)
		if skill1_enemy != null:
			skill_1_timer.start()
			normal_attack_timer.start()
			magician.play("skill1_front") if skill1_enemy.position.y > position.y else magician.play("skill1_back")
			return
	super()
	pass


func get_valid_skill1_enemy() -> Enemy:
	var enemy_list: Array[Enemy]
	for body in tower_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		if "special" in enemy.get_groups(): continue
		if "boss" in enemy.get_groups(): continue
		if enemy.unit_body.get_collision_layer_value(7): continue
		enemy_list.append(enemy)
	if enemy_list.is_empty(): return null
	var back_enemy: Enemy = enemy_list[0]
	for enemy in enemy_list:
		if enemy.bounty > back_enemy.bounty: back_enemy = enemy
	return back_enemy
	pass


func tower_skill_level_up(skill_id: int, skill_level: int):
	super(skill_id,skill_level)
	pass
