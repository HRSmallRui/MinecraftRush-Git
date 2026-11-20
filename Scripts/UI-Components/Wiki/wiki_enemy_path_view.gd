@tool
extends Line2D

@export var sampled_path: Curve2D
@export var update: bool:
	set(v):
		call_deferred("on_update")
@export_range(0,1) var hue_strength: float


func on_update():
	points = sampled_path.get_baked_points()
	pass
