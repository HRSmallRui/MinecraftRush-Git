extends Panel
class_name TimeIntervalBlockEditor

@onready var line_edit: LineEdit = $LineEdit


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = str(new_text.to_float())
	if new_text == "":
		new_text = "0"
	line_edit.text = new_text
	line_edit.release_focus()
	pass # Replace with function body.
