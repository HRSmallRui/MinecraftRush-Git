extends SkillConditionArea2D

@export var fork_sprite_scene: PackedScene
@export var dizness_buff_scene: PackedScene
@export var slow_buff_scene: PackedScene
@export var fork_count_list: Array[int]
@export var explosion_damage_list: Array[int]

var loop_count: int
var fork_list: Array[Sprite2D]
@onready var explosion_timer: Timer = $ExplosionTimer
@onready var explosion_area: Area2D = $ExplosionArea


func _ready() -> void:
	loop_count = fork_count_list[skill_level]
	var explosion_damage: int = explosion_damage_list[skill_level]
	for i in loop_count:
		var fork: Sprite2D = fork_sprite_scene.instantiate()
		add_child(fork)
		fork.position = Vector2(randf_range(-70,70),randf_range(-150,-140))
		var target_pos: Vector2 = Vector2(randf_range(-40,40),randf_range(-30,30))
		fork.look_at(target_pos + global_position)
		fork_list.append(fork)
		var fork_tween: Tween = create_tween()
		fork_tween.tween_property(fork,"position",target_pos,0.1)
		AudioManager.instance.play_fork_throw_audio()
		await fork_tween.finished
		for body in get_overlapping_bodies():
			var enemy: Enemy = body.owner
			enemy.take_damage(80,DataProcess.DamageType.PhysicsDamage,0)
	explosion_timer.start()
	await explosion_timer.timeout
	AudioManager.instance.play_explosion_audio()
	EffectManager.instance.play_explosion_effect(position)
	for body in explosion_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		var dizness_buff: PropertyBuff = dizness_buff_scene.instantiate()
		dizness_buff.buff_tag = "AlexSkill5Dizness"
		dizness_buff.unit = enemy
		enemy.buffs.add_child(dizness_buff)
		enemy.take_damage(explosion_damage,DataProcess.DamageType.ExplodeDamage,0,false,null,true)
	for fork in fork_list:
		create_tween().tween_property(fork,"modulate:a",0,0.4)
	await get_tree().create_timer(0.4,false).timeout
	queue_free()
	pass


func _on_speed_low_area_body_entered(body: Node2D) -> void:
	var enemy: Enemy = body.owner
	var speed_low_buff: PropertyBuff = slow_buff_scene.instantiate()
	speed_low_buff.buff_tag = "AlexSkill5SpeedLow"
	speed_low_buff.duration = 2
	speed_low_buff.unit = enemy
	enemy.buffs.add_child(speed_low_buff)
	pass # Replace with function body.
