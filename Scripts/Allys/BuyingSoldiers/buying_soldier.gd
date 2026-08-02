extends Ally
class_name BuyingSoldier

@export var linked_buying_tower: BuyingSoldierTower
@export var name_list: PackedStringArray


func _ready() -> void:
	super()
	ally_name = name_list[randi_range(0,name_list.size()-1)]
	pass


func die(explosion: bool = false):
	super(explosion)
	linked_buying_tower.buying_soldier_list.erase(self)
	linked_buying_tower.update_soldiers_position()
	await get_tree().create_timer(8,false).timeout
	queue_free()
	pass


func rebirth():
	
	pass
