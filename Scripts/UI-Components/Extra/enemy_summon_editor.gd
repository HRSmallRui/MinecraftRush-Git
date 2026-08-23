extends Control
class_name EnemySummonEditor

@export var bed_ui: BedUI
@export var enemy_block_scene: PackedScene
@export var time_block_scene: PackedScene

@onready var v_box_container: VBoxContainer = $EnemySelectContainer/VBoxContainer
@onready var summon_list_1: VBoxContainer = $HBoxContainer/ScrollContainer/SummonList1
@onready var summon_list_2: VBoxContainer = $HBoxContainer/ScrollContainer2/SummonList2
@onready var summon_list_3: VBoxContainer = $HBoxContainer/ScrollContainer3/SummonList3
@onready var marker_1: Marker2D = $Marker1
@onready var marker_2: Marker2D = $Marker2
@onready var marker_3: Marker2D = $Marker3
@onready var enemy_select_container: ScrollContainer = $EnemySelectContainer

var data_name_library: Dictionary
var data_texture_library: Dictionary
var digital_fighting_saver: DigitalFightingSaver
var current_request_editor: EnemySummonBlockEditor

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
	var block: EnemySummonBlockDigitalFighting = EnemySummonBlockDigitalFighting.new()
	digital_fighting_saver.summon_block_list[0].summon_list.append(block)
	var enemy_block: EnemySummonBlockEditor = enemy_block_scene.instantiate()
	enemy_block.list_id = 0
	add_enemy_summon_block(summon_list_1,enemy_block,block)
	pass # Replace with function body.


func _on_add_time_button_1_pressed() -> void:
	var block: WaitTimeBlock = WaitTimeBlock.new()
	digital_fighting_saver.summon_block_list[0].summon_list.append(block)
	var time_block: TimeIntervalBlockEditor = time_block_scene.instantiate()
	time_block.list_id = 0
	add_time_interbal_block(summon_list_1,time_block,block)
	pass # Replace with function body.


func _on_add_enemy_button_2_pressed() -> void:
	var block: EnemySummonBlockDigitalFighting = EnemySummonBlockDigitalFighting.new()
	digital_fighting_saver.summon_block_list[1].summon_list.append(block)
	var enemy_block: EnemySummonBlockEditor = enemy_block_scene.instantiate()
	enemy_block.list_id = 1
	add_enemy_summon_block(summon_list_2,enemy_block,block)
	pass # Replace with function body.


func _on_add_time_button_2_pressed() -> void:
	var block: WaitTimeBlock = WaitTimeBlock.new()
	digital_fighting_saver.summon_block_list[1].summon_list.append(block)
	var time_block: TimeIntervalBlockEditor = time_block_scene.instantiate()
	time_block.list_id = 1
	add_time_interbal_block(summon_list_2,time_block,block)
	pass # Replace with function body.


func _on_add_enemy_button_3_pressed() -> void:
	var block: EnemySummonBlockDigitalFighting = EnemySummonBlockDigitalFighting.new()
	digital_fighting_saver.summon_block_list[2].summon_list.append(block)
	var enemy_block: EnemySummonBlockEditor = enemy_block_scene.instantiate()
	enemy_block.list_id = 2
	add_enemy_summon_block(summon_list_3,enemy_block,block)
	pass # Replace with function body.


func _on_add_time_button_3_pressed() -> void:
	var block: WaitTimeBlock = WaitTimeBlock.new()
	digital_fighting_saver.summon_block_list[2].summon_list.append(block)
	var time_block: TimeIntervalBlockEditor = time_block_scene.instantiate()
	time_block.list_id = 2
	add_time_interbal_block(summon_list_3,time_block,block)
	pass # Replace with function body.


func summon_blocks_initalize():
	if digital_fighting_saver.summon_block_list.is_empty():
		for i in 3:
			digital_fighting_saver.summon_block_list.append(SummonWaveBlock.new())
	
	list_initialize(summon_list_1,digital_fighting_saver.summon_block_list[0].summon_list,0)
	list_initialize(summon_list_2,digital_fighting_saver.summon_block_list[1].summon_list,1)
	list_initialize(summon_list_3,digital_fighting_saver.summon_block_list[2].summon_list,2)
	pass


func add_enemy_summon_block(parent_list: Control, block: EnemySummonBlockEditor, linked_block: EnemySummonBlockDigitalFighting):
	block.linked_block = linked_block
	block.trash_button.connect(trash_enemy_block_editor)
	block.id_change_request.connect(on_editor_change_request)
	parent_list.add_child(block)
	block.enemy_name_label.text = data_name_library[block.enemy_id]
	block.enemy_texture_rect.texture = data_texture_library[block.enemy_id]
	pass


func add_time_interbal_block(parent_list: Control, block: TimeIntervalBlockEditor, linked_block: WaitTimeBlock):
	block.linked_block = linked_block
	block.trash_button.connect(trash_time_block_editor)
	parent_list.add_child(block)
	pass


func trash_enemy_block_editor(editor: EnemySummonBlockEditor):
	editor.queue_free()
	digital_fighting_saver.summon_block_list[editor.list_id].summon_list.erase(editor.linked_block)
	pass


func trash_time_block_editor(editor: TimeIntervalBlockEditor):
	editor.queue_free()
	digital_fighting_saver.summon_block_list[editor.list_id].summon_list.erase(editor.linked_block)
	pass


func list_initialize(list_container: VBoxContainer, block_list: Array[SummonBlock], list_id: int):
	for block in block_list:
		if block is EnemySummonBlockDigitalFighting:
			var editor_block: EnemySummonBlockEditor = enemy_block_scene.instantiate()
			editor_block.list_id = list_id
			add_enemy_summon_block(list_container,editor_block,block)
		if block is WaitTimeBlock:
			var editor_block: TimeIntervalBlockEditor = time_block_scene.instantiate()
			editor_block.list_id = list_id
			add_time_interbal_block(list_container,editor_block,block)
	pass


func on_editor_change_request(editor: EnemySummonBlockEditor):
	if current_request_editor == editor:
		current_request_editor = null
		enemy_select_container.hide()
		return
	
	current_request_editor = editor
	enemy_select_container.show()
	var target_pos: Vector2 = marker_1.position if editor.list_id == 0 else\
	marker_2.position if editor.list_id == 1 else marker_3.position
	enemy_select_container.position = target_pos
	
	pass


func change_editor(change_id: int):
	if current_request_editor != null:
		current_request_editor.enemy_id = change_id
		current_request_editor.enemy_name_label.text = data_name_library[current_request_editor.enemy_id]
		current_request_editor.enemy_texture_rect.texture = data_texture_library[current_request_editor.enemy_id]
		current_request_editor.linked_block.enemy_id = change_id
	
	enemy_select_container.hide()
	current_request_editor = null
	pass
