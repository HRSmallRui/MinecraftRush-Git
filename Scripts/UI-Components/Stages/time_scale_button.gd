extends Button

var button_level: int = 0
var time_scale_list: Array[float] = [1,1.5,2]


func _on_pressed() -> void:
	button_level += 1
	if button_level >= time_scale_list.size():
		button_level = 0
	Global.time_scale = time_scale_list[button_level]
	match button_level:
		0: text = ">"
		1: text = ">>"
		2: text = ">>>"
	pass # Replace with function body.
