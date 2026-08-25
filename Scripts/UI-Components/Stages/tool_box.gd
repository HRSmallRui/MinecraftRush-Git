extends Control

@onready var button_container: VBoxContainer = $ButtonContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel_container: PanelContainer = $PanelContainer

var enter_status: bool


func _ready() -> void:
	panel_container.hide()
	button_container.hide()
	pass


func _on_crafting_table_button_pressed() -> void:
	if enter_status:
		animation_player.play_backwards("enter")
		button_container.hide()
		#panel_container.hide()
	else:
		animation_player.play("enter")
		button_container.show()
		panel_container.show()
	enter_status = ! enter_status
	pass # Replace with function body.
