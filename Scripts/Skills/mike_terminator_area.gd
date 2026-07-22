extends SkillConditionArea2D

@export var max_point_limit: int = 20
@export var damage_block: DamageBlock

@onready var fire_sprite: AnimatedSprite2D = $FireSprite
@onready var tail_line: Line2D = $TailLine
@onready var shadow: Sprite2D = $Shadow
@onready var bomb: Sprite2D = $Bomb
@onready var dark_time_light: PointLight2D = $Bomb/DarkTimeLight


func _ready() -> void:
	bomb.scale = Vector2.ZERO
	tail_line.clear_points()
	fire_sprite.position.y = -1200
	if randf_range(0,1) < 0.5:
		shadow.position.x = -1000
		fire_sprite.position.x = -1000
	else:
		fire_sprite.position.x = 1000
		shadow.position.x = 1000
	fire_sprite.look_at(self.global_position)
	fire_sprite.rotation_degrees += 180
	shadow.modulate.a = 0
	var fire_tween: Tween = create_tween()
	var fly_time: float = 0.5
	fire_tween.tween_property(fire_sprite,"position",Vector2.ZERO,fly_time)
	create_tween().tween_property(shadow,"position",Vector2.ZERO,fly_time)
	create_tween().tween_property(shadow,"modulate:a",1,fly_time)
	await fire_tween.finished
	create_tween().tween_property(bomb,"scale",Vector2.ONE * 0.6,0.6)
	create_tween().tween_property(bomb,"modulate:a",0,0.5)
	create_tween().tween_property(dark_time_light,"energy",0,0.5)
	fire_sprite.hide()
	shadow.hide()
	AudioManager.instance.play_explosion_audio()
	EffectManager.instance.play_explosion_effect(position)
	EffectManager.instance.play_fire_effect(position)
	EffectManager.instance.play_smoke_effect(position)
	Stage.instance.stage_camera.shake(10)
	for body in get_overlapping_bodies():
		var enemy: Enemy = body.owner
		enemy.take_damage(damage_block.get_damage(),DataProcess.DamageType.SuperDamage,0,false,null,false,true)
	
	await get_tree().create_timer(2,false).timeout
	queue_free()
	pass


func _on_tail_timer_timeout() -> void:
	tail_line.add_point(fire_sprite.global_position)
	if tail_line.get_point_count() >= max_point_limit:
		tail_line.remove_point(0)
	pass # Replace with function body.
