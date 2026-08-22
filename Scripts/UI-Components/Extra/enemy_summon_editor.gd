extends Control
class_name EnemySummonEditor

@export var bed_ui: BedUI
@export var enemy_block_scene: PackedScene
@export var time_block_scene: PackedScene

@onready var v_box_container: VBoxContainer = $ScrollContainer/VBoxContainer
@onready var summon_list_1: VBoxContainer = $HBoxContainer/ScrollContainer/SummonList1
@onready var summon_list_2: VBoxContainer = $HBoxContainer/ScrollContainer2/SummonList2
@onready var summon_list_3: VBoxContainer = $HBoxContainer/ScrollContainer3/SummonList3

var data_name_library: Dictionary
var data_texture_library: Dictionary
var digital_fighting_saver: DigitalFightingSaver

func _ready() -> void:
	library_initialize()
	digital_fighting_saver = bed_ui.digital_saver
	summon_blocks_initalize()
	pass


func library_initialize():
	for regestor_button: EnemyRegestorButton in v_box_container.get_children():
		data_name_library[regestor_button.enemy_id] = regestor_button.enemy_name
		data_texture_library[regestor_button.enemy_id] = regestor_button.enemy_texture
	pass


func _on_back_button_pressed() -> void:
	queue_free()
	ExtraContent.instance.ui_state = ExtraContent.ExtraUIState.Bed
	DigitalFightingSaver.save_digital_fighting_saver(digital_fighting_saver)
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_released("escape"):
		await get_tree().process_frame
		_on_back_button_pressed()
	pass


func _on_add_enemy_button_1_pressed() -> void:
	
	pass # Replace with function body.


func _on_add_time_button_1_pressed() -> void:
	
	pass # Replace with function body.


func _on_add_enemy_button_2_pressed() -> void:
	
	pass # Replace with function body.


func _on_add_time_button_2_pressed() -> void:
	
	pass # Replace with function body.


func _on_add_enemy_button_3_pressed() -> void:
	
	pass # Replace with function body.


func _on_add_time_button_3_pressed() -> void:
	
	pass # Replace with function body.


func summon_blocks_initalize():
	if digital_fighting_saver.summon_block_list.is_empty():
		for i in 3:
			digital_fighting_saver.summon_block_list.append(SummonWaveBlock.new())
	pass


func add_enemy_summon_block(parent_list: Control, block: EnemySummonBlockEditor, linked_block: EnemySummonBlockDigitalFighting):
	
	pass


func add_time_interbal_block(parent_list: Control, block: TimeIntervalBlockEditor, linked_block: WaitTimeBlock):
	
	pass
