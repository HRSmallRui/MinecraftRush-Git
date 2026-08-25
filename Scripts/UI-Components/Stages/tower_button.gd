extends Button

@export_file("*.tscn") var tower_scene_path: String
@export var tower_name: String
@export var tower_texture: Texture2D

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	label.text = tower_name
	texture_rect.texture = tower_texture
	pass
