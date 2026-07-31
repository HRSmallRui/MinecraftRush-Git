extends StoryLayer

@export var stage1_scene: PackedScene

@onready var opening: AudioStreamPlayer = $Opening


func _ready() -> void:
	super()
	await get_tree().create_timer(82).timeout
	create_tween().tween_property(opening,"volume_db",-50,8)
	pass


func on_queue_free():
	get_tree().change_scene_to_packed(stage1_scene)
	pass
