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
@onready var enemy_multi_instance: MultiMeshInstance2D = $MapUILayer/CenterContainer/MapTexture/EnemyMultiInstance
@onready var ally_multi_instance: MultiMeshInstance2D = $MapUILayer/CenterContainer/MapTexture/AllyMultiInstance

var map_texture_mouse_in: bool
var enemy_list: Array[Enemy]
var ally_list: Array[Ally]

func _ready() -> void:
	update_map_image()
	Stage.instance.ui_update.connect(ui_process)
	enemy_multi_instance.multimesh.instance_count = 1000
	ally_multi_instance.multimesh.instance_count = 1000
	await get_tree().process_frame
	camera_control.position = Stage.instance.stage_camera.get_screen_center_position() - Stage.instance.stage_based_position
	camera_control.scale = Vector2.ONE / Stage.instance.stage_camera.zoom
	map_camera_control.position = Stage.instance.stage_camera.get_screen_center_position() - Stage.instance.stage_based_position
	map_camera_control.scale = Vector2.ONE / Stage.instance.stage_camera.zoom
	pass


func update_map_image():
	map_button.texture_normal = map_image
	map_button.position.x = -map_button.size.x
	map_texture.texture = map_image
	await get_tree().process_frame
	set_scale_rate()
	pass


func _process(delta: float) -> void:
	camera_control.position = Stage.instance.stage_camera.get_screen_center_position() - Stage.instance.stage_based_position
	camera_control.scale = Vector2.ONE / Stage.instance.stage_camera.zoom
	map_camera_control.position = Stage.instance.stage_camera.get_screen_center_position() - Stage.instance.stage_based_position
	map_camera_control.scale = Vector2.ONE / Stage.instance.stage_camera.zoom
	if map_ui_layer.visible:
		update_map_input()
	pass


func _on_map_button_pressed() -> void:
	on_ui_layer_show()
	pass # Replace with function body.


func _on_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		on_ui_layer_hide()
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
		on_ui_layer_hide()
	
	if event.is_action_released("map_visible"):
		if map_ui_layer.visible: on_ui_layer_hide()
		else: on_ui_layer_show()
	pass


func _on_update_timer_timeout() -> void:
	update_enemy_points()
	update_ally_points()
	pass # Replace with function body.


func update_enemy_points():
	var idx: int = 0
	for enemy in enemy_list:
		var t: Transform2D = Transform2D()
		if !enemy.visible: continue
		var point_position: Vector2 = enemy.global_position - Stage.instance.stage_based_position
		if point_position.x < 0 or point_position.y < 0: continue
		if point_position.x > map_texture.size.x or point_position.y > map_texture.size.y: continue
		t.origin = point_position
		enemy_multi_instance.multimesh.set_instance_transform_2d(idx,t)
		idx += 1
	enemy_multi_instance.multimesh.visible_instance_count = idx
	pass


func update_ally_points():
	var idx: int = 0
	for ally in ally_list:
		var t: Transform2D = Transform2D()
		var point_position: Vector2 = ally.global_position - Stage.instance.stage_based_position
		if point_position.x < 0 or point_position.y < 0: continue
		if point_position.x > map_texture.size.x or point_position.y > map_texture.size.y: continue
		t.origin = point_position
		ally_multi_instance.multimesh.set_instance_transform_2d(idx,t)
		idx += 1
	ally_multi_instance.multimesh.visible_instance_count = idx
	pass


func on_ui_layer_show():
	map_ui_layer.show()
	Stage.instance.can_control = false
	Stage.instance.ui_process(null)
	pass


func on_ui_layer_hide():
	map_ui_layer.hide()
	map_texture_mouse_in = false
	Stage.instance.can_control = true
	pass


func ui_process(member: Node):
	if Stage.instance.stage_ui == Stage.StageUI.None or Stage.instance.stage_ui == Stage.StageUI.Check:
		map_button.mouse_filter = Control.MOUSE_FILTER_STOP
	else:
		map_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass
