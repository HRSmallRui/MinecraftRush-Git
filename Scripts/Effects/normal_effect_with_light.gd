extends AnimatedSprite2D

@export var light_disappearing_time: float = 0.5

@onready var dark_time_light: PointLight2D = $DarkTimeLight


func _ready() -> void:
	create_tween().tween_property(dark_time_light,"energy",0,light_disappearing_time)
	await animation_finished
	queue_free()
	pass
