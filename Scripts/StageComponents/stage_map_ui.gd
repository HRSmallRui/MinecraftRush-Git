extends Control
class_name StageMapUI

@export var map_image: Texture2D:
	set(v):
		map_image = v
		if has_node("MapButton"): update_map_image()

@onready var map_button: TextureButton = $MapButton
@onready var camera_control: Control = $MapButton/CameraControl
@onready var map_ui_layer: CanvasLayer = $MapUILayer
@onready var map_texture: TextureRect = $MapUILayer/CenterContainer/MapTexture
@onready var map_camera_control: Control = $MapUILayer/CenterContainer/MapTexture/MapCameraControl
@onready var center_container: CenterContainer = $MapUILayer/CenterContainer

var map_texture_mouse_in: bool


func _ready() -> void:
	update_map_image()
	pass


func update_map_image():
	map_button.texture_normal = map_image
	map_button.position.x = -map_button.size.x
	map_texture.texture = map_image
	await get_tree().process_frame
	set_scale_rate()
	pass


func _process(delta: float) -> void:
	camera_control.position = Stage.instance.stage_camera.get_screen_center_position()
	camera_control.scale = Vector2.ONE / Stage.instance.stage_camera.zoom
	map_camera_control.position = Stage.instance.stage_camera.get_screen_center_position()
	map_camera_control.scale = Vector2.ONE / Stage.instance.stage_camera.zoom
	if map_ui_layer.visible:
		update_map_input()
	pass


func _on_map_button_pressed() -> void:
	map_ui_layer.show()
	Stage.instance.can_control = false
	pass # Replace with function body.


func _on_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		map_ui_layer.hide()
		map_texture_mouse_in = false
		Stage.instance.can_control = true
	pass # Replace with function body.


func set_scale_rate():
	var x_scale_rate: float = 1920.0 / center_container.size.x
	var y_scale_rate: float = 1080.0 / center_container.size.y
	center_container.scale = Vector2.ONE * minf(x_scale_rate,y_scale_rate) * 0.8
	var raw_size: Vector2 = center_container.size * center_container.scale
	center_container.position = (Vector2(1920,1080) - raw_size) / 2
	pass


func update_map_input():
	if map_texture_mouse_in and Input.is_action_pressed("click"):
		var camera_pos: Vector2 = map_texture.get_local_mouse_position()
		Stage.instance.stage_camera.position = camera_pos
		Stage.instance.stage_camera.position_clamp()
	pass


func _on_map_texture_mouse_entered() -> void:
	map_texture_mouse_in = true
	pass # Replace with function body.


func _on_map_texture_mouse_exited() -> void:
	map_texture_mouse_in = false
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_released("escape") and map_ui_layer.visible:
		map_ui_layer.hide()
		map_texture_mouse_in = false
		Stage.instance.can_control = true
	pass
