extends TextureRect

@export var tip_text: String


func _on_mouse_entered() -> void:
	WikiManager.instance.tip_show(tip_text)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	WikiManager.instance.tip_hide()
	pass # Replace with function body.
