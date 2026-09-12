@tool
extends PanelContainer

@export_multiline var tip_text: String:
	set(v):
		tip_text = v
		call_deferred("update_text")

@onready var label: Label = $MarginContainer/Label


func update_text():
	label.text = tip_text
	pass
