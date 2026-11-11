@tool
extends TextureButton

@export_file("*.tscn") var target_page_path: String
@export var target_page_pos: float = 0
@export var name_text: String:
	set(v):
		name_text = v
		call_deferred("update_text")
@export var font_color_override: bool
@export var font_color: Color:
	set(v):
		font_color = v
		if font_color_override:
			call_deferred("on_color_changed")

@onready var name_label: Label = $NameLabel


func update_text():
	name_label.text = name_text
	pass


func _on_pressed() -> void:
	if target_page_path != "":
		WikiManager.instance.into_new_wiki_page(target_page_path,0,target_page_pos)
	else:
		WikiManager.instance.current_wiki_page.into_target_pos(target_page_pos)
	pass # Replace with function body.


func on_color_changed():
	name_label.add_theme_color_override("font_color",font_color)
	pass
