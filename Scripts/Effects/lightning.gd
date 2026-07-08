extends Line2D

@export var point_array: PackedVector2Array

@onready var delay_timer: Timer = $DelayTimer
@onready var lightning_light: PointLight2D = $LightningLight


func _ready() -> void:
	lightning_light.visible = Stage.instance.is_dark_time
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
	pass # Replace with function body.
