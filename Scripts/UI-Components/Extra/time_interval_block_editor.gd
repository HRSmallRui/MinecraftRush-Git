extends Panel
class_name TimeIntervalBlockEditor

signal trash_button(editor: TimeIntervalBlockEditor)

@onready var line_edit: LineEdit = $LineEdit

var linked_block: WaitTimeBlock
var time_interval: float
var list_id: int


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = str(new_text.to_float())
	if new_text == "":
		new_text = "0"
	line_edit.text = new_text
	line_edit.release_focus()
	pass # Replace with function body.


func _on_trash_button_pressed() -> void:
	trash_button.emit(self)
	pass # Replace with function body.
