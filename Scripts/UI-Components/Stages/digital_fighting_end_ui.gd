extends CanvasLayer

@export_file("*.tscn") var back_path: String


func _ready() -> void:
	get_tree().paused = true
	
	pass


func _on_finish_button_pressed() -> void:
	Global.change_scene(back_path)
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and !$AnimationPlayer.is_playing():
		_on_finish_button_pressed()
	pass
