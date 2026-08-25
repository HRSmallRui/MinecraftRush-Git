extends Button

@export var tool_box_ui: ToolBoxUI
@export_file("*.tscn") var tower_scene_path: String
@export var tower_name: String
@export var tower_texture: Texture2D
@export var tower_skill_limit_list: Array[int]
@export var tower_skill_name_list: Array[String]

@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	label.text = tower_name
	texture_rect.texture = tower_texture
	pass


func _pressed() -> void:
	tool_box_ui.tower_build_request.emit(tower_scene_path,tower_name,tower_texture,tower_skill_limit_list,tower_skill_name_list)
	
	pass
