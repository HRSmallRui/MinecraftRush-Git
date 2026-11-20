@tool
extends CenterContainer

@export var calculate_total_money: bool:
	set(v):
		call_deferred("on_calculating_money")
@export var linked_table: WikiStageConfigTable
@export var total_wave_count: int
@export var summon_block_list: Array[PathSummonList]
@export var loading: bool:
	set(v):
		on_loading_configs()

@onready var money_table: Label = $WikiTable/WikiTableElement2/MoneyTable


func _ready() -> void:
	on_loading_configs()
	on_calculating_money()
	pass


func on_loading_configs():
	summon_block_list = linked_table.summon_block_list
	pass


func on_calculating_money():
	var total_money: int = 0
	for i in total_wave_count:
		total_money += get_wave_money(i+1)
	money_table.text = str(total_money)
	pass


func get_wave_money(wave_count: int) -> int:
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
	return total_money
