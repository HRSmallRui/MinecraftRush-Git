extends Stage
class_name DigitalFightingStage

var digital_sav: DigitalFightingSaver


func _init() -> void:
	Global.current_sav_slot = 0
	super()
	stage_sav = GameSaver.new()
	digital_sav = DigitalFightingSaver.get_digital_fighting_saver()
	stage_sav.select_hero_id = digital_sav.hero_id
	stage_sav.upgrade_sav = digital_sav.tech_level_list.duplicate()
	stage_sav.difficulty = digital_sav.difficulty
	stage_sav.challenge_mode_tip = true
	stage_sav.challenge_level_tip = true
	stage_sav.hero_sav.clear()
	for i in HeroSavBlock.hero_sav_block_library.size():
		var sav_block: HeroSavBlock = HeroSavBlock.new(10)
		sav_block.skill_levels = [3,3,3,3,3]
		stage_sav.hero_sav.append(sav_block)
	pass


func _ready() -> void:
	super()
	stage_map.hide()
	stage_map.process_mode = Node.PROCESS_MODE_DISABLED
	var path_id: int = 0
	for enemy_path: EnemyPath in enemies.get_children():
		if path_id >= 3: break
		enemy_path.path_summon_config.wave_summon_list.append(digital_sav.summon_block_list[path_id])
		path_id += 1
	pass


func add_hero_skill_button():
	if digital_sav.ban_hero: return
	super()
	pass


func summon_hero(summon_pos:Vector2 = hero_summon_marker.position):
	if digital_sav.ban_hero: return
	super(summon_pos)
	pass


func _process(delta: float) -> void:
	super(delta)
	current_money = 1000
	pass


func initalize_load_enemy():
	for wave_block: SummonWaveBlock in digital_sav.summon_block_list:
		for summon_block:SummonBlock in wave_block.summon_list:
			if summon_block is EnemySummonBlockDigitalFighting:
				load(EnemyPath.enemy_registor_path_list[summon_block.enemy_id])
	pass
