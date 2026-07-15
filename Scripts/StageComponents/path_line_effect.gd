extends Line2D
class_name PathLineEffect

static var instance: PathLineEffect

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _init() -> void:
	instance = self
	pass


func _ready() -> void:
	clear_points()
	pass


func show_path_line():
	animation_player.play("show")
	pass


func hide_path_line():
	animation_player.play_backwards("show")
	pass
