extends Control

enum TowerType{
	Archers,
	Barracks,
	Magics,
	Bombards,
	Others
}

@export var type_text_list: Array[String]

@onready var button_container: VBoxContainer = $ButtonContainer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var panel_container: PanelContainer = $PanelContainer
@onready var type_label: Label = $PanelContainer/MarginContainer2/TypeLabel

@onready var archer_group: ScrollContainer = $PanelContainer/MarginContainer/ArcherGroup
@onready var barrack_group: ScrollContainer = $PanelContainer/MarginContainer/BarrackGroup
@onready var magic_group: ScrollContainer = $PanelContainer/MarginContainer/MagicGroup
@onready var bombard_group: ScrollContainer = $PanelContainer/MarginContainer/BombardGroup
@onready var other_group: ScrollContainer = $PanelContainer/MarginContainer/OtherGroup

var enter_status: bool


func _ready() -> void:
	panel_container.hide()
	button_container.hide()
	update_slot_visible(TowerType.Archers)
	pass


func _on_crafting_table_button_pressed() -> void:
	if enter_status:
		animation_player.play_backwards("enter")
		button_container.hide()
		#panel_container.hide()
		Stage.instance.can_control = true
	else:
		animation_player.play("enter")
		button_container.show()
		panel_container.show()
		Stage.instance.can_control = false
	enter_status = ! enter_status
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_released("escape") and enter_status:
		_on_crafting_table_button_pressed()
	pass


func _on_archer_button_pressed() -> void:
	update_slot_visible(TowerType.Archers)
	pass # Replace with function body.


func _on_barrack_button_pressed() -> void:
	update_slot_visible(TowerType.Barracks)
	pass # Replace with function body.


func _on_magic_button_pressed() -> void:
	update_slot_visible(TowerType.Magics)
	pass # Replace with function body.


func _on_bombard_button_pressed() -> void:
	update_slot_visible(TowerType.Bombards)
	pass # Replace with function body.


func _on_buying_button_pressed() -> void:
	update_slot_visible(TowerType.Others)
	pass # Replace with function body.


func update_slot_visible(current_type: TowerType):
	type_label.text = type_text_list[current_type]
	archer_group.visible = current_type == TowerType.Archers
	barrack_group.visible = current_type == TowerType.Barracks
	magic_group.visible = current_type == TowerType.Magics
	bombard_group.visible = current_type == TowerType.Bombards
	other_group.visible = current_type == TowerType.Others
	pass
