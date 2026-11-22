@tool
extends ScrollContainer
class_name WikiStageConfigTable

@export var update: bool:
	set(v):
		if Engine.is_editor_hint():
			call_deferred("on_update")
@export var wave_font_color_list: Array[Color]
@export var total_wave_count: int
@export var summon_block_list: Array[PathSummonList]

@export var loading_configs: bool:
	set(v):
		on_loading_configs()
@export_dir var loading_path: String

@export_group("Refs")
@export var wiki_table_element_scene: PackedScene

@onready var wiki_table: GridContainer = $WikiTable


func _ready() -> void:
	on_update()
	pass


func on_loading_configs():
	var new_list: Array[PathSummonList]
	for i in wave_font_color_list.size() * 3:
		var file_name: String = "path" + str(i+1) + ".res"
		file_name = loading_path + "/" + file_name
		new_list.append(load(file_name))
	if not new_list.is_empty():
		summon_block_list = new_list
	pass


func on_update():
	for element in wiki_table.get_children():
		wiki_table.remove_child(element)
	wiki_table.columns = 2 + wave_font_color_list.size()
	create_table_head()
	add_table_body()
	pass

func create_table_head():
	add_table_element("波次")
	for i in wave_font_color_list.size():
		var label_text: String = "第" + str(i+1) + "路"
		add_table_element(label_text, wave_font_color_list[i])
	add_table_element("总经济")
	pass


func add_table_element(element_text: String, lable_color: Color = Color.BLACK):
	var element: PanelContainer = wiki_table_element_scene.instantiate()
	element.custom_minimum_size.x = 250
	var label: Label = Label.new()
	label.text = element_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	#label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.add_theme_constant_override("line_spacing",5)
	if lable_color != Color.BLACK:
		label.add_theme_color_override("font_color",lable_color)
	var margin: MarginContainer = MarginContainer.new()
	margin.add_theme_constant_override("margin_top",15)
	margin.add_theme_constant_override("margin_bottom",15)
	margin.add_theme_constant_override("margin_left",10)
	margin.add_theme_constant_override("margin_right",10)
	margin.add_child(label)
	element.add_child(margin)
	wiki_table.add_child(element)
	pass


func add_table_body():
	for i in total_wave_count:
		add_table_element(str(i+1))
		for j in wave_font_color_list.size():
			var font_color: Color = wave_font_color_list[j] * 0.8
			font_color.a = 1
			add_table_element(get_enemy_text_block([summon_block_list[3*j],summon_block_list[3*j+1],summon_block_list[3*j+2]],i+1),font_color)
		add_table_element(get_wave_money_text(i+1))
	pass


func get_enemy_text_block(enemy_block_group: Array[PathSummonList],wave_count: int) -> String:
	var text_dic: Dictionary
	for block in enemy_block_group:
		var wave_block: SummonWaveBlock = block.wave_summon_list[wave_count-1]
		for summon in wave_block.summon_list:
			if not summon is WaitTimeBlock:
				var id: String = SummonCountProcess.enemy_id_to_string(summon.enemy_id)
				if text_dic.has(id):
					text_dic[SummonCountProcess.enemy_id_to_string(summon.enemy_id)] += summon.summon_count
				else:
					text_dic[SummonCountProcess.enemy_id_to_string(summon.enemy_id)] = summon.summon_count
	var back_string: String = ""
	#print(text_dic)
	for id in text_dic:
		back_string += id + " x " + str(text_dic[id]) + "\n"
	return back_string
	pass


func get_wave_money_text(wave_count: int) -> String:
	var list: Dictionary
	for block in summon_block_list:
		var wave_block: SummonWaveBlock = block.wave_summon_list[wave_count-1]
		for summon in wave_block.summon_list:
			if not summon is WaitTimeBlock:
				var id: int = summon.enemy_id
				if list.has(id):
					list[id] += summon.summon_count
				else:
					list[id] = summon.summon_count
	#print(list)
	var total_money: int = 0
	for id in list:
		total_money += SummonCountProcess.get_enemy_bounty(id) * list[id]
	return str(total_money)


func _on_scroll_started() -> void:
	WikiManager.instance.scroll_locked = true
	pass # Replace with function body.


func _on_scroll_ended() -> void:
	WikiManager.instance.scroll_locked = false
	pass # Replace with function body.
