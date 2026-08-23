extends Stage

var digital_sav: DigitalFightingSaver


func _init() -> void:
	super()
	stage_sav = GameSaver.new()
	digital_sav = DigitalFightingSaver.get_digital_fighting_saver()
	stage_sav.select_hero_id = digital_sav.hero_id
	stage_sav.upgrade_sav = digital_sav.tech_level_list.duplicate()
	stage_sav.difficulty = digital_sav.difficulty
	pass


func _ready() -> void:
	super()
	stage_map.queue_free()
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
