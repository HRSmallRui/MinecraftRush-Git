extends Button

@export var wiki_page: WikiPage
@export var target_pos: float
@export var linked_part: VBoxContainer
@export_group("Themes")
@export var white_theme: Theme
@export var dark_theme: Theme


func _ready() -> void:
	theme = dark_theme if DisplayServer.is_dark_mode() else white_theme
	pass


func _pressed() -> void:
	if linked_part != null:
		wiki_page.into_target_pos(wiki_page.global_position.y-linked_part.global_position.y + 20)
	else:
		wiki_page.into_target_pos(target_pos)
	pass
