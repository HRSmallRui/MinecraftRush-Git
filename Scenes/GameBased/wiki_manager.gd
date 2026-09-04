extends Control
class_name WikiManager

static var instance: WikiManager

@onready var white_background: Sprite2D = $WhiteBackground
@onready var dark_background: Sprite2D = $DarkBackground


func _init() -> void:
	instance = self
	pass


func _ready() -> void:
	into_color_mode(DisplayServer.is_dark_mode())
	pass


func into_color_mode(is_dark_mode: bool):
	white_background.visible = !is_dark_mode
	dark_background.visible = is_dark_mode
	pass
