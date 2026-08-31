extends Area2D
class_name FirerainSkill

@export var fire_land_scene: PackedScene

@onready var fire_rock_sprite: AnimatedSprite2D = $FireRockSprite
@onready var shadow: Sprite2D = $Shadow
@onready var destroy_timer: Timer = $DestroyTimer
@onready var water_condition_area: Area2D = $WaterConditionArea


var skill_level: int
var in_water: bool


func _ready() -> void:
	fire_rock_sprite.position = Vector2(-1920,-1080)
	shadow.position.x = -1920
	create_tween().tween_property(fire_rock_sprite,"position",Vector2.ZERO,0.6)
	create_tween().tween_property(shadow,"position:x",0,0.6)
	await destroy_timer.timeout
	attack_process()
	fire_land_process()
	hide()
	await get_tree().create_timer(0.2,false).timeout
	queue_free()
	pass


func attack_process():
	for hurt_box in get_overlapping_areas():
		var hurter = hurt_box.owner
		var damage: int
		match skill_level:
			0: damage = randi_range(40,60)
			1,2: damage = randi_range(50,80)
			3,4: damage = randi_range(60,120)
			5: damage = randi_range(100,140)
		if hurter is Enemy:
			hurter.take_damage(damage,DataProcess.DamageType.TrueDamage,0,false,null,false)
	
	AudioManager.instance.play_explosion_audio()
	EffectManager.instance.play_explosion_effect(position)
	EffectManager.instance.play_smoke_effect(position)
	EffectManager.instance.play_fire_effect(position)
	
	if water_condition_area.has_overlapping_areas():
		AudioManager.instance.play_water_audio()
		EffectManager.instance.play_block_effect(position+Vector2(0,20),Vector2.ONE*1.5,Color(0,0.8,1,0.6))
		in_water = true
	pass


func fire_land_process():
	if skill_level < 2: return
	var fire_land: FireHurtArea = fire_land_scene.instantiate()
	fire_land.position = position
	fire_land.in_water = in_water
	match skill_level:
		2,3: fire_land.skill_level = 1
		4,5: fire_land.skill_level = 2
	Stage.instance.bullets.add_child(fire_land)
	pass
