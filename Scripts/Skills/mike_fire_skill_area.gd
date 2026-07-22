extends Area2D

@export var max_point_limit: int = 40
@export var holy_fire_buff_scene: PackedScene
@export var fire_damage: IntSaver

@onready var fire_sprite: AnimatedSprite2D = $FireSprite
@onready var tail_line: Line2D = $TailLine
@onready var shadow: Sprite2D = $Shadow
@onready var tail_timer: Timer = $TailTimer
@onready var bomb: Sprite2D = $Bomb
@onready var dark_time_light: PointLight2D = $Bomb/DarkTimeLight


func _ready() -> void:
	bomb.scale = Vector2.ZERO
	tail_line.clear_points()
	fire_sprite.position.y -= 1200
	fire_sprite.position.x += 100 if randi_range(0,1) == 0 else -100
	shadow.position.x = fire_sprite.position.x
	fire_sprite.look_at(global_position)
	fire_sprite.rotation_degrees += 180
	var fly_time: float = 0.8
	shadow.modulate.a = 0
	var fire_tween: Tween = create_tween().set_ease(Tween.EASE_IN)
	fire_tween.tween_property(fire_sprite,"position",Vector2.ZERO,fly_time).set_ease(Tween.EASE_IN)
	create_tween().tween_property(shadow,"position",Vector2.ZERO,fly_time).set_ease(Tween.EASE_IN)
	create_tween().tween_property(shadow,"modulate:a",1,fly_time).set_ease(Tween.EASE_IN)
	await fire_tween.finished
	AudioManager.instance.play_explosion_audio()
	Stage.instance.stage_camera.shake(20)
	create_tween().tween_property(bomb,"scale",Vector2.ONE * 1,0.8)
	create_tween().tween_property(bomb,"modulate:a",0,0.8)
	create_tween().tween_property(dark_time_light,"energy",0,0.6)
	fire_sprite.hide()
	EffectManager.instance.play_explosion_effect(position,Vector2.ONE*2)
	EffectManager.instance.play_smoke_effect(position,Vector2.ONE*2)
	shadow.hide()
	EffectManager.instance.play_fire_effect(position,Vector2.ONE*2)
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		if enemy.enemy_type < Enemy.EnemyType.MiniBoss:
			enemy.sec_kill(true)
		else:
			var damage: int = fire_damage.saving_int_value
			enemy.take_damage(damage,DataProcess.DamageType.SuperDamage,0,false,null,false,true,)
			var holy_fire: DotBuff = holy_fire_buff_scene.instantiate()
			enemy.buffs.add_child(holy_fire)
	pass


func _on_tail_timer_timeout() -> void:
	tail_line.add_point(fire_sprite.global_position)
	if tail_line.get_point_count() >= max_point_limit:
		tail_line.remove_point(0)
	pass # Replace with function body.
