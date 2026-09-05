extends Panel
class_name WikiPage

var max_pos_y: float


func _enter_tree() -> void:
	theme = null
	pass


func _ready() -> void:
	max_pos_y = maxf(0,size.y - 1080)
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		position.y += 50
	elif event.is_action_pressed("scroll_down"):
		position.y -= 50
	elif event is InputEventScreenDrag:
		position.y += event.screen_relative.y
	
	update_scroll()
	pass


func update_scroll():
	position.y = clampf(position.y,-max_pos_y,0)
	pass
