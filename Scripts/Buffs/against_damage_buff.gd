extends BuffClass
class_name AgainstDamageBuff

enum AgainstType
{
	StaticDamage,
	RateDamage
}

@export var only_near_damage_against: bool = true
@export var against_type: AgainstType
@export var static_damage_list: Array[int]
@export var against_rate_list: Array[float]
@export var use_final_damage: bool
@export var against_damage_type: DataProcess.DamageType = DataProcess.DamageType.TrueDamage
@export var against_broken_rate: float
@export var against_explosion: bool
@export var against_deadly: bool = true


func buff_start():
	super()
	data_owner.on_take_damage.connect(on_owner_take_damage)
	pass


func on_owner_take_damage(damage_event: DamageEventData):
	if unit is Ally:
		if unit.ally_state == Ally.AllyState.DIE: return
	if unit is Enemy:
		if unit.enemy_state == Enemy.EnemyState.DIE: return
	var source: Node2D = damage_event.source
	if source == null: return
	if only_near_damage_against and damage_event.far_attack: return
	
	var against_damage: int
	match against_type:
		AgainstType.StaticDamage: against_damage = static_damage_list[buff_level-1]
		AgainstType.RateDamage:
			against_damage = damage_event.final_damage if use_final_damage else damage_event.raw_damage
			against_damage *= against_rate_list[buff_level-1]
	
	if source is Ally:
		source.take_damage(against_damage,against_damage_type,against_broken_rate,false,null,against_explosion,false,against_deadly)
	if source is Enemy:
		source.take_damage(against_damage,against_damage_type,against_broken_rate,false,null,against_explosion,false,against_deadly)
		print("against_enemy")
	pass
