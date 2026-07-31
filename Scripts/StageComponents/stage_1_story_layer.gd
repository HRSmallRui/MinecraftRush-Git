extends StoryLayer

@export var stage1_scene: PackedScene

@onready var opening: AudioStreamPlayer = $Opening


func disappear():
	super()
	create_tween().tween_property(opening,"volume_db",-100,0.5)
	pass


func on_queue_free():
	get_tree().change_scene_to_packed(stage1_scene)
	pass
