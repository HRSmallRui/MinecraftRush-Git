extends TextureButton

@export var button_text: String
@export_file("*.tscn") var linked_path: String
@export_group("ThemeTextures")
@export var white_theme_texture: Texture2D
@export var dark_theme_texture: Texture2D

@onready var label: Label = $Label


func _ready() -> void:
	texture_normal = dark_theme_texture if DisplayServer.is_dark_mode() else white_theme_texture
	label.text = button_text
	pass


func _process(delta: float) -> void:
	var hover_modulate: Color = Color.WHITE * 1.2
	hover_modulate.a = 1
	var pressed_modulate: Color = Color.WHITE * 0.8
	pressed_modulate.a = 1
	
	if get_draw_mode() == DrawMode.DRAW_NORMAL:
		self_modulate = Color.WHITE
	elif get_draw_mode() == DrawMode.DRAW_HOVER:
		self_modulate = hover_modulate
	elif get_draw_mode() == DrawMode.DRAW_PRESSED:
		self_modulate = pressed_modulate
	pass


func _pressed() -> void:
	WikiManager.instance.into_new_wiki_page(linked_path)
	pass
