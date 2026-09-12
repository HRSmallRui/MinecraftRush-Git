extends Panel
class_name WikiPage

var max_pos_y: float

#var mouse_delta_position: Vector2
var last_frame_mouse_position: Vector2

var current_velocity: float


func _enter_tree() -> void:
	theme = null
	pass


func _ready() -> void:
	max_pos_y = maxf(0,size.y - 1080)
	last_frame_mouse_position = get_local_mouse_position()
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("scroll_up"):
		position.y += 50
		current_velocity = 0
	elif event.is_action_pressed("scroll_down"):
		position.y -= 50
		current_velocity = 0
	
	update_scroll()
	pass


func _process(delta: float) -> void:
	#mouse_delta_position = get_local_mouse_position() - last_frame_mouse_position
	last_frame_mouse_position = get_local_mouse_position()
	position.y += current_velocity * delta
	current_velocity = snappedf(lerpf(current_velocity,0,2 * delta),0.1)
	if abs(current_velocity) <= 10: current_velocity = 0
	update_scroll()
	pass


func update_scroll():
	position.y = clampf(position.y,-max_pos_y,0)
	pass


func into_target_pos(target_pos: float):
	position.y = target_pos
	update_scroll()
	pass


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		current_velocity = 0
	elif event.is_action_released("click"):
		current_velocity = Input.get_last_mouse_velocity().y
	elif event is InputEventScreenDrag:
		position.y += event.relative.y
	
	update_scroll()
	pass # Replace with function body.
