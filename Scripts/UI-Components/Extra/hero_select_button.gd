extends TextureButton

signal hero_select(select_id: int)

@export var hero_id: int


func _pressed() -> void:
	hero_select.emit(hero_id)
	pass
