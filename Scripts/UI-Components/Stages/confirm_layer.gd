extends CanvasLayer

@export var tool_box_ui: ToolBoxUI

@onready var name_label: Label = $NameLabel
@onready var texture_rect: TextureRect = $TextureRect

var tower_scene_path: String
var tower_name: String
var tower_texture: Texture2D
var tower_skill_limit_list: Array[int]
var tower_skill_name_list: Array[String]

var current_skill_list: Array[int]


func _on_tool_box_tower_build_request(tower_scene_path: String, tower_name: String, tower_texture: Texture2D,
 tower_skill_limit_list: Array[int], tower_skill_name_list: Array[String]) -> void:
	show()
	get_tree().paused = true
	self.tower_scene_path = tower_scene_path
	self.tower_name = tower_name
	self.tower_texture = tower_texture
	self.tower_skill_limit_list = tower_skill_limit_list
	self.tower_skill_name_list = tower_skill_name_list
	current_skill_list = tower_skill_limit_list.duplicate()
	confirm_layer_initialize()
	pass # Replace with function body.


func _on_confirm_button_pressed() -> void:
	hide()
	get_tree().paused = false
	apply_tower_build()
	pass # Replace with function body.


func _on_cancel_button_pressed() -> void:
	hide()
	get_tree().paused = false
	pass # Replace with function body.


func confirm_layer_initialize():
	name_label.text = tower_name
	texture_rect.texture = tower_texture
	pass


func apply_tower_build():
	var tower_scene: PackedScene = load(tower_scene_path)
	if tower_scene == null: return
	var tower_pos_list: Array[Vector2]
	for tower: DefenceTower in Stage.instance.towers.get_children():
		tower_pos_list.append(tower.position)
		tower.destroy_tower()
	for tower: DefenceTower in Stage.instance.towers.get_children():
		tower.queue_free()
	for tower_pos: Vector2 in tower_pos_list:
		var tower:DefenceTower = tower_scene.instantiate()
		if tower is BarrackTower: tower.is_new_tower = true
		tower.position = tower_pos
		tower.tower_skill_levels = current_skill_list.duplicate()
		Stage.instance.towers.add_child(tower)
	pass
