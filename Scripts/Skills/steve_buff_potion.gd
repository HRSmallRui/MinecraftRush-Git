extends Area2D

@export var potion_color: Color
@export var potion_slash_effect_scene: PackedScene
@export var heal_data: int
@export var undead_damage: int
@export var super_heal_buff_scene: PackedScene

@onready var splash_1: AudioStreamPlayer = $Splash1
@onready var splash_2: AudioStreamPlayer = $Splash2
@onready var splash_3: AudioStreamPlayer = $Splash3
@onready var damage_area: Area2D = $DamageArea


func _ready() -> void:
	
	pass


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.frame == 11:
		match randi_range(1,3):
			1: splash_1.play()
			2: splash_2.play()
			3: splash_3.play()
		
		EffectManager.instance.play_sprite_effect(potion_slash_effect_scene,position,Vector2.ONE,potion_color)
		
		for hurt_box: HurtBox in get_overlapping_areas():
			var unit = hurt_box.owner
			if unit is Ally:
				unit.current_data.heal(heal_data)
				unit.buffs.add_child(super_heal_buff_scene.instantiate())
		
		for hurt_box in damage_area.get_overlapping_areas():
			var unit = hurt_box.owner
			if unit is Enemy and "undead" in unit.get_groups():
				unit.take_damage(undead_damage,DataProcess.DamageType.TrueDamage,0,true,null,)
	pass # Replace with function body.


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
	pass # Replace with function body.
