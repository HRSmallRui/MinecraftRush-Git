extends SkillButton

@export var lightning_area_scene: PackedScene
@export var lightning_damage_block: DamageBlock
@export var slow_buff_scene: PackedScene
@export var lightning_count_list: Array[int]
@export var rain_duration_list: Array[float]

@onready var rain_timer: Timer = $RainTimer
@onready var robort_rain_layer: CanvasLayer = $RobortRainLayer
@onready var rain_audio_super: AudioStreamPlayer = $RainAudioSuper
@onready var rain_shot_timer: Timer = $RainShotTimer
@onready var enemy_condition_area: Area2D = $EnemyConditionArea
@onready var collision_shape_2d: CollisionShape2D = $EnemyConditionArea/CollisionShape2D
@onready var black_light: PointLight2D = $BlackLight

var level: int
var is_raining: bool


func _ready() -> void:
	super()
	remove_child(enemy_condition_area)
	Stage.instance.bullets.add_child(enemy_condition_area)
	var target_collision: CollisionShape2D = Stage.instance.click_area.get_child(0)
	collision_shape_2d.position = target_collision.position
	collision_shape_2d.shape = target_collision.shape
	
	level = Stage.instance.get_hero_skill_level(4)
	robort_rain_layer.hide()
	rain_timer.wait_time = rain_duration_list[level]
	
	var colli_shape: CollisionShape2D = Stage.instance.click_area.get_child(0) as CollisionShape2D
	var shape: Shape2D = colli_shape.shape
	black_light.position = colli_shape.global_position
	black_light.scale = shape.get_rect().size
	pass


func skill_unlease_condition():
	if Stage.instance.mouse_in_path and !Stage.instance.mouse_in_fire_stop_area:
		skill_unlease()
	pass


func skill_unlease():
	super()
	release_lightning(Stage.instance.get_local_mouse_position())
	release_raining()
	pass


func release_lightning(release_position: Vector2):
	var loop_count: int =lightning_count_list[level]
	for i in loop_count:
		var lightning_area: SkillConditionArea2D = lightning_area_scene.instantiate()
		lightning_area.position = release_position + Vector2(randf_range(-60,60),randf_range(-45,45))
		Stage.instance.bullets.add_child(lightning_area)
		await get_tree().create_timer(0.4,false).timeout
	pass


func release_raining():
	if "desert" in Stage.instance.stage_environment_tags: return
	
	rain_audio_super.play()
	robort_rain_layer.show()
	rain_timer.start()
	rain_shot_timer.start()
	is_raining = true
	if RainSystem.instance == null:
		create_tween().tween_property(black_light,"energy",0.4,0.4)
	elif RainSystem.instance.current_rain_step <= RainSystem.RainStep.Small:
		create_tween().tween_property(black_light,"energy",0.2,0.4)
	
	await rain_timer.timeout
	rain_audio_super.stop()
	robort_rain_layer.hide()
	rain_shot_timer.stop()
	is_raining = false
	if RainSystem.instance == null:
		Stage.instance.is_dark_time = false
	else:
		Stage.instance.is_dark_time = RainSystem.instance.current_rain_step > RainSystem.RainStep.None
	create_tween().tween_property(black_light,"energy",0,0.5)
	pass


func _on_rain_shot_timer_timeout() -> void:
	for body in enemy_condition_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		var slow_buff: PropertyBuff = slow_buff_scene.instantiate()
		enemy.buffs.add_child(slow_buff)
	pass # Replace with function body.


func _process(delta: float) -> void:
	super(delta)
	if is_raining:
		Stage.instance.is_dark_time = true
	pass
