extends GridContainer

@export var white_theme: Theme
@export var dark_theme: Theme


func _ready() -> void:
	theme = dark_theme if DisplayServer.is_dark_mode() else white_theme
	pass
