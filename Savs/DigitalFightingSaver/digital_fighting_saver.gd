extends Resource
class_name DigitalFightingSaver

@export var hero_id: int
@export var tech_level_list: Array[int] = [0,0,0,0,0,0]
@export var summon_block_list: Array[SummonWaveBlock]
@export var ban_hero: bool = false
@export var select_map_id: int
@export var difficulty: GameSaver.Difficulty = GameSaver.Difficulty.NORMAL


static func get_digital_fighting_saver() -> DigitalFightingSaver:
	if OS.get_name() == "Windows" and OS.is_debug_build():
		return load("res://Savs/digital_fighting_saver.tres")
	else:
		return load("user://digital_fighting_saver.tres")


static func save_digital_fighting_saver(sav: DigitalFightingSaver):
	if OS.get_name() == "Windows" and OS.is_debug_build():
		ResourceSaver.save(sav,"res://Savs/digital_fighting_saver.tres")
	else:
		ResourceSaver.save(sav,"user://digital_fighting_saver.tres")
