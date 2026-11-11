extends Control
class_name WikiManager

static var instance: WikiManager

@export var white_mode_theme: Theme
@export var dark_mode_theme: Theme
@export var current_wiki_page: WikiPage

@export_file("*.tscn") var back_page_stack: Array[String]
@export var back_page_step_stack: Array[float]
@export_file("*.tscn") var front_page_stack: Array[String]

@onready var white_background: Sprite2D = $WhiteBackground
@onready var dark_background: Sprite2D = $DarkBackground
@onready var content_page: Control = $ContentPage

@onready var back_button: TextureButton = $ButtonGroup/BackButton
@onready var home_button: TextureButton = $ButtonGroup/HomeButton
@onready var front_button: TextureButton = $ButtonGroup/FrontButton
@onready var tip_panel: PanelContainer = $TipPanel
@onready var tip_label: Label = $TipPanel/MarginContainer/TipLabel

var scroll_locked: bool = false


func _init() -> void:
	instance = self
	pass


func _ready() -> void:
	into_color_mode(DisplayServer.is_dark_mode())
	update_button_states()
	tip_panel.hide()
	pass


func update_button_states():
	back_button.disabled = back_page_stack.size() <= 1
	back_button.modulate = Color.GRAY if back_button.disabled else Color.WHITE
	back_button.mouse_default_cursor_shape = Control.CURSOR_ARROW if back_button.disabled else Control.CURSOR_POINTING_HAND
	front_button.disabled = front_page_stack.size() == 0
	front_button.modulate = Color.GRAY if front_button.disabled else Color.WHITE
	front_button.mouse_default_cursor_shape = Control.CURSOR_ARROW if front_button.disabled else Control.CURSOR_POINTING_HAND
	home_button.disabled = back_page_stack[-1] == "res://Scenes/WikiPages/wiki_page_index.tscn"
	home_button.modulate = Color.GRAY if home_button.disabled else Color.WHITE
	home_button.mouse_default_cursor_shape = Control.CURSOR_ARROW if home_button.disabled else Control.CURSOR_POINTING_HAND
	pass


func into_color_mode(is_dark_mode: bool):
	white_background.visible = !is_dark_mode
	dark_background.visible = is_dark_mode
	theme = dark_mode_theme if is_dark_mode else white_mode_theme
	pass


func into_new_wiki_page(page_path: String, mode: int = 0, target_pos: float = 0):
	if page_path.length() == 0: return
	if mode == 0:
		back_page_stack.append(page_path)
		front_page_stack.clear()
	if not content_page.get_children().is_empty():
		if mode == 0:
			var current_page: WikiPage = content_page.get_child(0)
			back_page_step_stack[-1] = current_page.position.y
			back_page_step_stack.append(0)
		content_page.get_child(0).queue_free()
	var new_wiki_page_scene: PackedScene = load(page_path)
	var new_wiki_page: WikiPage = new_wiki_page_scene.instantiate()
	current_wiki_page = new_wiki_page
	content_page.add_child(new_wiki_page)
	new_wiki_page.position.y = target_pos
	new_wiki_page.update_scroll()
	
	update_button_states()
	pass


func _on_back_button_pressed() -> void:
	into_new_wiki_page(back_page_stack[back_page_stack.size()-2],1)
	front_page_stack.append(back_page_stack[back_page_stack.size()-1])
	back_page_stack.remove_at(back_page_stack.size()-1)
	back_page_step_stack.remove_at(back_page_step_stack.size()-1)
	update_button_states()
	var current_page: WikiPage = content_page.get_child(-1)
	current_page.position.y = back_page_step_stack[back_page_step_stack.size()-1]
	pass # Replace with function body.


func _on_home_button_pressed() -> void:
	var home_path: String = "res://Scenes/WikiPages/wiki_page_index.tscn"
	into_new_wiki_page(home_path)
	pass # Replace with function body.


func _on_front_button_pressed() -> void:
	into_new_wiki_page(front_page_stack[front_page_stack.size()-1],1)
	back_page_stack.append(front_page_stack[front_page_stack.size()-1])
	front_page_stack.remove_at(front_page_stack.size()-1)
	back_page_step_stack.append(0)
	update_button_states()
	pass # Replace with function body.


func _process(delta: float) -> void:
	tip_panel.global_position = get_local_mouse_position()
	pass


func tip_show(tip_text: String):
	tip_panel.show()
	tip_label.text = tip_text
	tip_panel.size.x = 0
	pass


func tip_hide():
	tip_panel.hide()
	tip_panel.size.x = 0
	pass
