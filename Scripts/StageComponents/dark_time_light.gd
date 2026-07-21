extends PointLight2D


func _process(delta: float) -> void:
	enabled = Stage.instance.is_dark_time
	pass
