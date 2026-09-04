extends TextureButton

@export var button_text: String
@export_group("ThemeTextures")
@export var white_theme_texture: Texture2D
@export var dark_theme_texture: Texture2D

@onready var label: Label = $Label


func _ready() -> void:
	texture_normal = dark_theme_texture if DisplayServer.is_dark_mode() else white_theme_texture
	label.text = button_text
	pass
