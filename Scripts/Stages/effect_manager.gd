extends Node
class_name EffectManager

static var instance: EffectManager

@export var explosion_effect_scene: PackedScene
@export var smoke_effect_scene: PackedScene
@export var fire_effect_scene: PackedScene


func _init() -> void:
	instance = self
	pass


func play_explosion_effect(summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE):
	play_sprite_effect(explosion_effect_scene,summon_pos,effect_scale)
	pass


func play_smoke_effect(summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE):
	play_sprite_effect(smoke_effect_scene,summon_pos,effect_scale)
	pass


func play_fire_effect(summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE):
	play_sprite_effect(fire_effect_scene,summon_pos,effect_scale)
	pass


func play_sprite_effect(effect_scene: PackedScene, summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE):
	var effect: AnimatedSprite2D = effect_scene.instantiate()
	effect.position = summon_pos
	effect_scale = effect_scale
	Stage.instance.bullets.add_child(effect)
	pass
