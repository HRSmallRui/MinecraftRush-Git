extends Control
class_name EnemySummonEditor

@export var bed_ui: BedUI

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer

var data_name_library: Dictionary
var data_texture_library: Dictionary

func _ready() -> void:
	library_initialize()
	pass


func library_initialize():
	for regestor_button: EnemyRegestorButton in v_box_container.get_children():
		data_name_library[regestor_button.enemy_id] = regestor_button.enemy_name
		data_texture_library[regestor_button.enemy_id] = regestor_button.enemy_texture
	pass
