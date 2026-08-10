extends CanvasLayer
class_name CheckPointNode

static var instance: CheckPointNode


func _ready() -> void:
	Stage.instance.on_check_point_enabled.connect(on_stage_saver_point_enabled)
	await get_tree().process_frame
	on_stage_saver_point_enabled()
	pass


func on_stage_saver_point_enabled():
	var check_point_saver: CheckPointSaver = CheckPointSaver.new()
	for hero: Hero in Stage.instance.hero_list:
		var hero_block: HeroPackedSavBlock = HeroPackedSavBlock.new()
		var packed_scene: PackedScene = PackedScene.new()
		packed_scene.pack(hero)
		hero_block.ally_packed_scene = packed_scene
		hero_block.ally_position = hero.position
		hero_block.ally_station_position = hero.station_position
		hero_block.ally_intercepting_area_pos = hero.intercepting_area.position
		check_point_saver.hero_sav_block_list.append(hero_block)
	for tower: DefenceTower in Stage.instance.towers.get_children():
		var tower_block: TowerPackedSavBlock = TowerPackedSavBlock.new()
		var tower_scene: PackedScene = PackedScene.new()
		tower_scene.pack(tower)
		tower_block.tower_packed_scene = tower_scene
		tower_block.tower_position = tower.position
		tower_block.tower_skill_levels = tower.tower_skill_levels
		check_point_saver.tower_sav_block_list.append(tower_block)
	
	check_point_saver.current_health = Stage.instance.current_health
	check_point_saver.current_money = Stage.instance.current_money
	save_check_point_saver(check_point_saver)
	pass


func save_check_point_saver(sav: CheckPointSaver):
	if OS.get_name() == "Windows" and OS.is_debug_build():
		debug_sav(sav)
	else:
		release_sav(sav)
	pass


func debug_sav(sav: CheckPointSaver):
	var dir_path: String = "res://Savs/CheckPointSaver/Sav" + str(Global.current_sav_slot) + "/"
	var path: String = dir_path + "stage" + str(Stage.instance.stage_count) + "_check_point_saver.tres"
	var dir: DirAccess = DirAccess.open("res://")
	if !dir.dir_exists(dir_path):
		dir.make_dir(dir_path)
	ResourceSaver.save(sav,path)
	pass


func release_sav(sav: CheckPointSaver):
	
	pass
