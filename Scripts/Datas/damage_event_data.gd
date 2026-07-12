extends RefCounted
class_name DamageEventData


var raw_damage: int
var final_damage: int
var damage_type: DataProcess.DamageType
var broken_rate: float
var far_attack: bool
var source: Node2D
var explosion: bool
var deadly: bool

func _init(p_raw: int, p_final: int, p_type: DataProcess.DamageType, p_broken_rate: float, p_far: bool,\
p_source: Node2D, p_explosion: bool, p_deadly: bool) -> void:
	raw_damage = p_raw
	final_damage = p_final
	damage_type = p_type
	broken_rate = p_broken_rate
	far_attack = p_far
	source = p_source
	explosion = p_explosion
	deadly = p_deadly
	pass
