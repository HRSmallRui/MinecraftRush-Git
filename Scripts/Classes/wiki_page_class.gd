extends Panel
class_name WikiPage

@export var white_mode_color: Color
@export var dark_mode_color: Color


func _ready() -> void:
	call_deferred("set_color_mode")
	pass


func set_color_mode():
	var is_dark_mode: bool = DisplayServer.is_dark_mode()
	self_modulate = dark_mode_color if is_dark_mode else white_mode_color
	WikiManager.instance.into_color_mode(is_dark_mode)
	pass
