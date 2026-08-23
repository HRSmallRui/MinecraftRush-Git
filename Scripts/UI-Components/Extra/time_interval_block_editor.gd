extends Panel
class_name TimeIntervalBlockEditor

signal trash_button(editor: TimeIntervalBlockEditor)
signal on_cancel_click

@onready var line_edit: LineEdit = $LineEdit

var linked_block: WaitTimeBlock
var time_interval: float
var list_id: int


func _ready() -> void:
	if linked_block != null:
		time_interval = linked_block.wait_time
	line_edit.text = str(time_interval)
	pass


func _on_line_edit_text_submitted(new_text: String) -> void:
	new_text = str(maxf(0,new_text.to_float()))
	if new_text == "":
		new_text = "0"
	line_edit.text = new_text
	line_edit.release_focus()
	
	linked_block.wait_time = new_text.to_float()
	pass # Replace with function body.


func _on_trash_button_pressed() -> void:
	trash_button.emit(self)
	pass # Replace with function body.


func _on_line_edit_focus_entered() -> void:
	on_cancel_click.emit()
	pass # Replace with function body.


func _on_line_edit_focus_exited() -> void:
	on_cancel_click.emit()
	pass # Replace with function body.
