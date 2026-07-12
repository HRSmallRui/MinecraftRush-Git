extends Stage

@export var witch_tower_texture: Texture
@export var witch_tower_name: String
@export var witch_tower_group: DefenceTower.TowerType
@export var witch_tower_id: int
@export var special_tower_unlock_scene: PackedScene

@onready var stage_12_story_layer: StoryLayer = $Stage12StoryLayer


func _ready() -> void:
	if !Global.stage_first:
		stage_12_story_layer.queue_free()
	super()
	await get_tree().process_frame
	if stage_12_story_layer != null:
		await get_tree().create_timer(0.01,false).timeout
	var witch_tower_ui: TipUI = special_tower_unlock_scene.instantiate()
	witch_tower_ui.show_texture = witch_tower_texture
	witch_tower_ui.show_name = witch_tower_name
	witch_tower_ui.tower_group = witch_tower_group
	witch_tower_ui.tower_id = witch_tower_id
	add_child(witch_tower_ui)
	pass
