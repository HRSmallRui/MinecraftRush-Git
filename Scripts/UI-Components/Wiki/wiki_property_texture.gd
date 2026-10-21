@tool
extends TextureRect

enum PropertyState{
	NORMAL,
	UP,
	DOWN
}

@export var tip_text: String
@export var property_state: PropertyState:
	set(v):
		property_state = v
		call_deferred("update_state_icons")

@onready var up: TextureRect = $Up
@onready var down: TextureRect = $Down


func _on_mouse_entered() -> void:
	WikiManager.instance.tip_show(tip_text)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	WikiManager.instance.tip_hide()
	pass # Replace with function body.


func update_state_icons():
	up.visible = property_state == PropertyState.UP
	down.visible = property_state == PropertyState.DOWN
	pass
