extends BarrackTower

@export var upgrade_damage_list: Array[DamageBlock]
@export var upgrade_armor: FloatSaver


func tower_skill_level_up(skill_id: int, skill_level: int):
	super(skill_id,skill_level)
	if skill_id == 1:
		var damage_block: DamageBlock = upgrade_damage_list[skill_level-1]
		barrack_data.damage_low = damage_block.damage_low
		barrack_data.damage_high = damage_block.damage_high
		barrack_data.armor += upgrade_armor.saving_float_value
		for soldier in soldier_list:
			soldier.start_data.armor += upgrade_armor.saving_float_value
			soldier.current_data.update_armor()
			soldier.start_data.near_damage_low = damage_block.damage_low
			soldier.start_data.near_damage_high = damage_block.damage_high
			soldier.current_data.update_near_damage()
	pass
