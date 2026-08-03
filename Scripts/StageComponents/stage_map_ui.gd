extends Control
class_name StageMapUI

@export var map_image: Texture2D:
	set(v):
		map_image = v
		if has_node("MapButton"): update_map_image()

@onready var map_button: TextureButton = $MapButton
@onready var camera_control: Control = $MapButton/CameraControl


func _ready() -> void:
	update_map_image()
	pass


func update_map_image():
	map_button.texture_normal = map_image
	map_button.position.x = -map_button.size.x
	pass


func _process(delta: float) -> void:
	camera_control.position = Stage.instance.stage_camera.get_screen_center_position()
	camera_control.scale = Vector2.ONE / Stage.instance.stage_camera.zoom
	pass
