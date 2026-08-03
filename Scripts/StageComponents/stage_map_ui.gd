extends Control
class_name StageMapUI

@export var map_image: Texture2D:
	set(v):
		map_image = v
		if has_node("MapButton"): update_map_image()

@onready var map_button: TextureButton = $MapButton


func _ready() -> void:
	update_map_image()
	pass


func update_map_image():
	map_button.texture_normal = map_image
	map_button.position.x = -map_button.size.x
	map_button.position.y = -0.5 * map_button.size.y
	pass
