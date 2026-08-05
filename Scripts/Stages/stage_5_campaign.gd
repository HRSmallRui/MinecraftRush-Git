extends Stage

@export var witch_tower_texture: Texture
@export var witch_tower_name: String
@export var witch_tower_group: DefenceTower.TowerType
@export var witch_tower_id: int
@export var special_tower_unlock_scene: PackedScene
@export var story_layer_scene: PackedScene


func _ready() -> void:
	var story_layer: StoryLayer
	if Global.stage_first:
		story_layer = story_layer_scene.instantiate()
		add_child(story_layer)
	super()
	if story_layer != null:
		await get_tree().create_timer(0.01,false).timeout
	var church_tower_ui: TipUI = special_tower_unlock_scene.instantiate()
	church_tower_ui.show_texture = witch_tower_texture
	church_tower_ui.show_name = witch_tower_name
	church_tower_ui.tower_group = witch_tower_group
	church_tower_ui.tower_id = witch_tower_id
	add_child(church_tower_ui)
	pass
