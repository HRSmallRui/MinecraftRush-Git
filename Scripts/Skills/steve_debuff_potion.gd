extends Area2D

@export var potion_color: Color
@export var potion_slash_effect_scene: PackedScene
@export var slow_buff_scene: PackedScene
@export var potion_damage: DamageBlock

@onready var splash_1: AudioStreamPlayer = $Splash1
@onready var splash_2: AudioStreamPlayer = $Splash2
@onready var splash_3: AudioStreamPlayer = $Splash3


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame == 11:
		match randi_range(1,3):
			1: splash_1.play()
			2: splash_2.play()
			3: splash_3.play()
		
		EffectManager.instance.play_sprite_effect(potion_slash_effect_scene,position,Vector2.ONE,potion_color)
		
		for hurt_box: HurtBox in get_overlapping_areas():
			var unit = hurt_box.owner
			if unit is Enemy:
				if !"undead" in unit.get_groups():
					unit.take_damage(potion_damage.get_damage(),DataProcess.DamageType.MagicDamage,0,true,null,false)
				unit.buffs.add_child(slow_buff_scene.instantiate())
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.
