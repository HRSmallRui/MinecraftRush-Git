extends CanvasLayer
class_name CheckPointNode

signal on_loading_confirm

static var instance: CheckPointNode

@onready var ui_layer: Control = $UILayer

var save_saver: bool:
	set(v):
		on_stage_saver_point_enabled()

var load_saver: bool:
	set(v):
		load_checkpoint_saver()


func _init() -> void:
	instance = self
	pass


func _ready() -> void:
	var sav: CheckPointSaver
	if OS.get_name() == "Windows" and OS.is_debug_build():
		sav = debug_load_sav()
	if sav == null: return
	
	get_tree().paused = true
	ui_layer.show()
	pass


func on_stage_saver_point_enabled():
	var check_point_saver: CheckPointSaver = CheckPointSaver.new()
	if not Stage.instance.hero_list.is_empty():
		var hero: Hero = Stage.instance.hero_list[0]
		check_point_saver.hero_position = hero.position
	for tower: DefenceTower in Stage.instance.towers.get_children():
		var tower_block: TowerPackedSavBlock = TowerPackedSavBlock.new()
		var tower_scene: PackedScene = PackedScene.new()
		tower.ready_to_save()
		tower_scene.pack(tower)
		tower_block.tower_packed_scene = tower_scene
		tower_block.tower_position = tower.position
		tower_block.tower_skill_levels = tower.tower_skill_levels
		check_point_saver.tower_sav_block_list.append(tower_block)
	
	check_point_saver.current_health = Stage.instance.current_health
	check_point_saver.current_money = Stage.instance.current_money
	check_point_saver.current_wave_count = Stage.instance.current_wave
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


func debug_load_sav() -> CheckPointSaver:
	var dir_path: String = "res://Savs/CheckPointSaver/Sav" + str(Global.current_sav_slot) + "/stage" \
	+ str(Stage.instance.stage_count) + "_check_point_saver.tres"
	var sav: CheckPointSaver = load(dir_path)
	return sav


func release_load_sav() -> CheckPointSaver:
	var dir_path: String = "user://CheckPointSaver/Sav" + str(Global.current_sav_slot) + "/stage" \
	+ str(Stage.instance.stage_count) + "_check_point_saver.tres"
	var sav: CheckPointSaver = load(dir_path)
	return sav


func release_sav(sav: CheckPointSaver):
	var dir_path: String = "user://CheckPointSaver/Sav" + str(Global.current_sav_slot) + "/"
	var path: String = dir_path + "stage" + str(Stage.instance.stage_count) + "_check_point_saver.tres"
	var dir: DirAccess = DirAccess.open("res://")
	if !dir.dir_exists(dir_path):
		dir.make_dir(dir_path)
	ResourceSaver.save(sav,path)
	pass


func load_checkpoint_saver():
	var sav: CheckPointSaver
	if OS.get_name() == "Windows" and OS.is_debug_build():
		sav = debug_load_sav()
	
	if sav == null: return
	
	for tower:DefenceTower in Stage.instance.towers.get_children():
		tower.destroy_tower()
	for tower:DefenceTower in Stage.instance.towers.get_children():
		tower.queue_free()
	for tower_block in sav.tower_sav_block_list:
		var tower: DefenceTower = tower_block.tower_packed_scene.instantiate()
		if tower is BarrackTower:
			tower.is_new_tower = true
		tower.position = tower_block.tower_position
		tower.tower_skill_levels = tower_block.tower_skill_levels.duplicate()
		Stage.instance.towers.add_child(tower)
	
	Stage.instance.hero_summon_marker.global_position = sav.hero_position
	Stage.instance.current_health = sav.current_health
	Stage.instance.current_money = sav.current_money
	Stage.instance.current_wave = sav.current_wave_count
	pass


func _on_yes_button_pressed() -> void:
	get_tree().paused = false
	on_loading_confirm.emit()
	load_checkpoint_saver()
	hide()
	pass # Replace with function body.


func _on_no_button_pressed() -> void:
	get_tree().paused = false
	hide()
	pass # Replace with function body.
