extends StoryLayer

@export var stage1_scene: PackedScene

@onready var opening: AudioStreamPlayer = $Opening


func _ready() -> void:
	super()
	var origin_scale: Vector2 = cg_player.scale
	cg_player.scale = Vector2.ONE*2
	cg_player.self_modulate.a = 0
	create_tween().tween_property(cg_player,"self_modulate:a",1,6)
	create_tween().tween_property(cg_player,"scale",origin_scale,40)
	await get_tree().create_timer(82).timeout
	create_tween().tween_property(opening,"volume_db",-50,8)
	pass


func on_queue_free():
	get_tree().change_scene_to_packed(stage1_scene)
	pass
