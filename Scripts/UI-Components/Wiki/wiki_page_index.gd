extends WikiPage

@export_file("*.tscn") var main_title_pc_path: String
@export_file("*.tscn") var main_title_mobile_path: String


func _on_back_button_pressed() -> void:
	if OS.get_name() == "Android":
		Global.change_scene(main_title_mobile_path)
	else:
		Global.change_scene(main_title_pc_path)
	pass # Replace with function body.
