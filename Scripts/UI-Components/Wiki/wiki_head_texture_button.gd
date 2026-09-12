@tool
extends TextureButton

@export_file("*.tscn") var target_page_path: String
@export var name_text: String:
	set(v):
		name_text = v
		call_deferred("update_text")

@onready var name_label: Label = $NameLabel


func update_text():
	name_label.text = name_text
	pass


func _on_pressed() -> void:
	
	pass # Replace with function body.
