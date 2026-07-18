extends Node
class_name EffectManager

static var instance: EffectManager

@export var explosion_effect_scene: PackedScene
@export var smoke_effect_scene: PackedScene
@export var fire_effect_scene: PackedScene
@export var block_particle_scene: PackedScene
@export var lightning_scene: PackedScene


func _init() -> void:
	instance = self
	pass


func play_explosion_effect(summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE, effect_modulate: Color = Color.WHITE, z_index: int = 0):
	play_sprite_effect(explosion_effect_scene,summon_pos,effect_scale,effect_modulate,z_index)
	pass


func play_smoke_effect(summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE, effect_modulate: Color = Color.WHITE, z_index: int = 0):
	play_sprite_effect(explosion_effect_scene,summon_pos,effect_scale,effect_modulate,z_index)
	pass


func play_fire_effect(summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE, effect_modulate: Color = Color.WHITE, z_index: int = 0):
	play_sprite_effect(explosion_effect_scene,summon_pos,effect_scale,effect_modulate,z_index)
	pass


func play_block_effect(summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE, effect_modulate: Color = Color.WHITE, z_index: int = 0):
	play_sprite_effect(explosion_effect_scene,summon_pos,effect_scale,effect_modulate,z_index)
	pass


func play_sprite_effect(effect_scene: PackedScene, summon_pos: Vector2, effect_scale: Vector2 = Vector2.ONE, effect_modulate: Color = Color.WHITE, z_index: int = 0):
	var effect: AnimatedSprite2D = effect_scene.instantiate()
	effect.position = summon_pos
	effect.scale = effect_scale
	effect.modulate = effect_modulate
	effect.z_index = z_index
	Stage.instance.bullets.add_child(effect)
	pass


func play_lightning_effect(summon_pos: Vector2,effect_scale: Vector2 = Vector2.ONE, z_index: int = 0):
	var lightning: Line2D = lightning_scene.instantiate()
	lightning.position = summon_pos
	lightning.scale *= effect_scale
	if randf() < 0.5: lightning.scale.x *= -1
	lightning.z_index = z_index
	Stage.instance.bullets.add_child(lightning)
	pass
