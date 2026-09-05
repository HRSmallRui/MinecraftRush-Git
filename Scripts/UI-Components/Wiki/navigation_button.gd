extends Button

@export var wiki_page: WikiPage
@export var target_pos: float
@export_group("Themes")
@export var white_theme: Theme
@export var dark_theme: Theme


func _ready() -> void:
	theme = dark_theme if DisplayServer.is_dark_mode() else white_theme
	pass


func _pressed() -> void:
	wiki_page.into_target_pos(target_pos)
	pass
