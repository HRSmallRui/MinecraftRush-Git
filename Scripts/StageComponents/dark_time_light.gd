extends PointLight2D


func _ready() -> void:
	enabled = Stage.instance.is_dark_time
	pass


func _process(delta: float) -> void:
	enabled = Stage.instance.is_dark_time
	pass
