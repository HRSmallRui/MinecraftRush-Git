extends Node

signal hero_loading_done

@export_file("*.tscn") var hero_scene_path_list: Array[String]

var hero_scene: PackedScene
var loading_path: String
var progress: Array

var is_loading_done: bool = true


func _ready() -> void:
	set_process(false)
	pass


func load_async(path: String):
	loading_path = path
	ResourceLoader.load_threaded_request(path)
	set_process(true)
	is_loading_done = false
	pass


func _process(delta: float) -> void:
	ResourceLoader.load_threaded_get_status(loading_path,progress)
	print(progress)
	if progress[0] >= 0.99:
		hero_scene = ResourceLoader.load_threaded_get(loading_path)
		is_loading_done = true
		hero_loading_done.emit()
		set_process(false)
	pass


func clear_hero_scene():
	hero_scene = null
	pass
