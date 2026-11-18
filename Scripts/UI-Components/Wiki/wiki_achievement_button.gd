@tool
extends TextureButton

@export var achievement_name: String:
	set(v):
		achievement_name = v
		call_deferred("update_label")

@export var achievement_texture: Texture2D:
	set(v):
		achievement_texture = v
		call_deferred("update_texture")

@export_file("*.tscn") var target_page_path: String

@onready var achieve_name_label: Label = $AchieveNameLabel
@onready var achieve_texture: TextureRect = $AchieveTexture


func update_texture():
	achieve_texture.texture = achievement_texture
	pass


func update_label():
	achieve_name_label.text = achievement_name
	pass


func _pressed() -> void:
	if target_page_path != "":
		WikiManager.instance.into_new_wiki_page(target_page_path,0,0)
	else:
		WikiManager.instance.current_wiki_page.into_target_pos(0)
	pass
