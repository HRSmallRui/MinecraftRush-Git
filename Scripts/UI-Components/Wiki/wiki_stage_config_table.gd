@tool
extends ScrollContainer

@export var update: bool:
	set(v):
		call_deferred("on_update")
@export var wave_font_color_list: Array[Color]
@export var total_money_list: Array[int]
@export var config_block_list: Array[StageWaveEnemyTextConfigBlock]

@export_group("Refs")
@export var wiki_table_element_scene: PackedScene

@onready var wiki_table: GridContainer = $WikiTable


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
		var label_text: String = "第" + str(i+1) + "波"
		add_table_element(label_text, wave_font_color_list[i])
	add_table_element("总经济")
	pass


func add_table_element(element_text: String, lable_color: Color = Color.BLACK):
	var element = wiki_table_element_scene.instantiate()
	var label: Label = Label.new()
	label.text = element_text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	if lable_color != Color.BLACK:
		label.add_theme_color_override("font_color",lable_color)
	element.add_child(label)
	wiki_table.add_child(element)
	pass


func add_table_body():
	for i in total_money_list.size():
		add_table_element(str(i+1))
		
	pass


class StageWaveEnemyTextConfigBlock extends Resource:
	@export var enemy_text_list: Array[String]
