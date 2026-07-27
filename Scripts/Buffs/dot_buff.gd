extends BuffClass
class_name DotBuff

signal on_dot_buff_damaged(raw_damage: int, damage: int)

@export var dot_damage: Array[int]
@export var can_be_dead: bool = true ##可致死

@onready var dot_timer: Timer = $DotTimer


func _ready() -> void:
	super()
	dot_timer.start()
	pass


func _on_dot_timer_timeout() -> void:
	var damage: int = dot_damage[buff_level-1]
	var end_damage: int
	if unit is Ally:
		var origin_health: int = unit.current_data.health
		unit.take_damage(damage,DataProcess.DamageType.TrueDamage,0,false,null,false,false,can_be_dead)
		end_damage = origin_health - unit.current_data.health
	elif unit is Enemy:
		var origin_health: int = unit.current_data.health
		unit.take_damage(damage,DataProcess.DamageType.TrueDamage,0,false,null,false,false,can_be_dead)
		end_damage = origin_health - unit.current_data.health
	on_dot_buff_damaged.emit(damage,end_damage)
	pass # Replace with function body.
