extends Panel
class_name EnemySummonBlockEditor

signal trash_button(editor: EnemySummonBlockEditor)
signal id_change_request(requester: EnemySummonBlockEditor)
signal on_cancel_click

@onready var line_edit_time_interval: LineEdit = $LineEditTimeInterval
@onready var line_edit_summon_count: LineEdit = $LineEditSummonCount
@onready var enemy_texture_rect: TextureRect = $PopupButton/EnemyTextureRect
@onready var enemy_name_label: Label = $PopupButton/EnemyNameLabel

var enemy_id: int
var enemy_summon_count: int
var summon_time_interval: float
var linked_block: EnemySummonBlockDigitalFighting
var list_id: int


func _ready() -> void:
	if linked_block != null:
		enemy_id = linked_block.enemy_id
		enemy_summon_count = linked_block.summon_count
		summon_time_interval = linked_block.time_interval
	line_edit_summon_count.text = str(enemy_summon_count)
	line_edit_time_interval.text = str(summon_time_interval)
	pass


func _on_line_edit_time_interval_text_submitted(new_text: String) -> void:
	new_text = str(maxf(0,new_text.to_float()))
	
	if new_text == "":
		new_text = "0"
	
	line_edit_time_interval.text = new_text
	line_edit_time_interval.release_focus()
	
	linked_block.time_interval = new_text.to_float()
	pass # Replace with function body.


func _on_line_edit_summon_count_text_submitted(new_text: String) -> void:
	new_text = str(maxi(0,new_text.to_int()))
	
	if new_text == "":
		new_text = "0"
	
	line_edit_summon_count.text = new_text
	line_edit_summon_count.release_focus()
	
	linked_block.summon_count = new_text.to_int()
	pass # Replace with function body.


func _on_popup_button_pressed() -> void:
	id_change_request.emit(self)
	pass # Replace with function body.


func _on_trash_button_pressed() -> void:
	trash_button.emit(self)
	pass # Replace with function body.


func _on_line_edit_time_interval_focus_entered() -> void:
	on_cancel_click.emit()
	pass # Replace with function body.


func _on_line_edit_summon_count_focus_entered() -> void:
	on_cancel_click.emit()
	pass # Replace with function body.


func _on_line_edit_summon_count_focus_exited() -> void:
	on_cancel_click.emit()
	pass # Replace with function body.


func _on_line_edit_time_interval_focus_exited() -> void:
	on_cancel_click.emit()
	pass # Replace with function body.
