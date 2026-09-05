extends Control
class_name WikiManager

static var instance: WikiManager

@export var white_mode_theme: Theme
@export var dark_mode_theme: Theme

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
	theme = dark_mode_theme if is_dark_mode else white_mode_theme
	pass


func into_new_wiki_page(page_path: String):
	if page_path.length() == 0: return
	
	pass
