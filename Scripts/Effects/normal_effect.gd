extends AnimatedSprite2D

@onready var dark_time_light: PointLight2D = $DarkTimeLight


func _ready() -> void:
	create_tween().tween_property(dark_time_light,"energy",0,0.4)
	await animation_finished
	queue_free()
	pass
