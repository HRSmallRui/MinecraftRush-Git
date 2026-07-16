extends Line2D
class_name PathLineEffect

static var instance: PathLineEffect

@export var shader_speed_default: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _init() -> void:
	instance = self
	pass


func _ready() -> void:
	clear_points()
	Stage.instance.on_paused.connect(on_stage_paused)
	pass


func show_path_line():
	animation_player.play("show")
	pass


func hide_path_line():
	animation_player.play_backwards("show")
	pass


func on_stage_paused(paused: bool):
	var shader_materrial: ShaderMaterial = material
	shader_materrial.set_shader_parameter("speed",0 if paused else shader_speed_default)
	pass
