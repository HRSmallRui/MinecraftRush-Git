extends SkillConditionArea2D

@export var dizness_buff_scene: PackedScene
@export var speed_low_buff_scene: PackedScene
@export_group("SkillData")
@export var first_damage_list: Array[IntSaver]
@export var duration_list: Array[FloatSaver]
@export var damage_per_count: IntSaver
@export var dizness_duration: FloatSaver

@onready var fork_sprite: AnimatedSprite2D = $ForkSprite
@onready var shot_timer: Timer = $ShotTimer
@onready var duration_timer: Timer = $DurationTimer
@onready var shadow: Sprite2D = $Shadow
@onready var in_path_area: Area2D = $InPathArea
@onready var skill_audio: AudioStreamPlayer = $SkillAudio


func _ready() -> void:
	await get_tree().physics_frame
	await get_tree().physics_frame
	if !in_path_area.has_overlapping_areas(): 
		queue_free()
		return
	skill_audio.play()
	
	shadow.scale = Vector2.ZERO
	create_tween().tween_property(shadow,"scale",Vector2.ONE * 3.6,0.12)
	await get_tree().create_timer(0.12,false).timeout
	var damage: int = first_damage_list[skill_level-1].saving_int_value
	duration_timer.wait_time = duration_list[skill_level-1].saving_float_value
	duration_timer.start()
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		var dizness_buff: PropertyBuff = dizness_buff_scene.instantiate()
		dizness_buff.unit = enemy
		dizness_buff.buff_tag = "alex_dizness_4"
		dizness_buff.duration = dizness_duration.saving_float_value
		enemy.buffs.add_child(dizness_buff)
		enemy.take_damage(damage,DataProcess.DamageType.ExplodeDamage,0,)
	shot_timer.start()
	pass


func _on_shot_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		var speed_low_buff: PropertyBuff = speed_low_buff_scene.instantiate()
		speed_low_buff.unit = enemy
		enemy.buffs.add_child(speed_low_buff)
		enemy.take_damage(damage_per_count.saving_int_value,DataProcess.DamageType.PhysicsDamage,0)
	pass # Replace with function body.


func _on_duration_timer_timeout() -> void:
	shot_timer.stop()
	var disappear_tween: Tween = create_tween()
	disappear_tween.tween_property(self,"modulate:a",0,1)
	await disappear_tween.finished
	queue_free()
	pass # Replace with function body.
