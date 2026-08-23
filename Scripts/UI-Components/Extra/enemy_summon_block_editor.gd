extends Panel
class_name EnemySummonBlockEditor

signal trash_button(editor: EnemySummonBlockEditor)

@onready var line_edit_time_interval: LineEdit = $LineEditTimeInterval
@onready var line_edit_summon_count: LineEdit = $LineEditSummonCount
@onready var enemy_texture_rect: TextureRect = $PopupButton/EnemyTextureRect
@onready var enemy_name_label: Label = $PopupButton/EnemyNameLabel

var enemy_id: int
var enemy_summon_count: int
var summon_time_interval: float
var enemy_texture: Texture2D
var linked_block: EnemySummonBlockDigitalFighting
var list_id: int


func _on_line_edit_time_interval_text_submitted(new_text: String) -> void:
	new_text = str(new_text.to_float())
	
	if new_text == "":
		new_text = "0"
	
	line_edit_time_interval.text = new_text
	line_edit_time_interval.release_focus()
	pass # Replace with function body.


func _on_line_edit_summon_count_text_submitted(new_text: String) -> void:
	new_text = str(new_text.to_int())
	
	if new_text == "":
		new_text = "0"
	
	line_edit_summon_count.text = new_text
	line_edit_summon_count.release_focus()
	pass # Replace with function body.


func _on_popup_button_pressed() -> void:
	
	pass # Replace with function body.


func _on_trash_button_pressed() -> void:
	trash_button.emit(self)
	pass # Replace with function body.
