extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@export var aoe_damage: DamageBlock

var damage: int


func _ready() -> void:
	damage = aoe_damage.get_damage()
	#var explosion_radius: float = collision_shape_2d.shape.radius
	if Stage.instance.get_current_techno_level(3) >= 4:
		damage = aoe_damage.damage_high
	
	await get_tree().physics_frame
	await get_tree().physics_frame
	
	for hurt_box in get_overlapping_areas():
		var enemy: Enemy = hurt_box.owner
		#print(now_damage)
		enemy.take_damage(damage,DataProcess.DamageType.ExplodeDamage,0,true,self,false,true)
		if Stage.instance.get_current_techno_level(3) >= 5 and randf_range(0,1) < 0.15:
			var dizness_buff: DiznessBuff = preload("res://Scenes/Buffs/dizness_buff.tscn").instantiate()
			enemy.buffs.add_child(dizness_buff)
	pass
