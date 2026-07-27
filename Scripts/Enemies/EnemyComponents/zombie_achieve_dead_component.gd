extends Node


func _ready() -> void:
	var enemy: Enemy = owner
	enemy.enemy_died.connect(enemy_died)
	pass


func enemy_died():
	Achievement.achieve_int_add("DeadWalking",1,480)
	pass
