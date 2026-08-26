extends Soldier
class_name MedicalSoldier

@export var medical_buff_scene: PackedScene
@export var BLOOD_SOLDIERRES: SpriteFrames
@export var NORMAL_SOLDIER: SpriteFrames
@export var medical_plague_buff_scene: PackedScene
@export_group("Passive","passive")
@export var passive_heal_data: int
@export var passive_heal_time_interval: float
@export var passive_heal_effect_scene: PackedScene
@export_group("Skill1","skill1")
@export var skill1_buff_duration_list: Array[float]
@export_group("Skill2","skill2")
@export var skill2_far_damage_list: Array[DamageBlock]
@export_group("Skill3","skill3")
@export var skill3_heal_data_list: Array[int]

@onready var heal_animation_player: AnimationPlayer = $UnitBody/HealAnimationPlayer
@onready var heal_area: Area2D = $UnitBody/HealArea
@onready var skill_heal_timer: Timer = $SkillHealTimer
@onready var heal_audio: AudioStreamPlayer = $HealAudio
@onready var passive_heal_timer: Timer = $PassiveHealTimer


func _ready() -> void:
	super()
	passive_heal_timer.wait_time = passive_heal_time_interval
	ally_sprite.sprite_frames = NORMAL_SOLDIER
	skill_initialize()
	await get_tree().create_timer(randf_range(1,2),false).timeout
	passive_heal_timer.start()
	pass


func anim_offset():
	match ally_sprite.animation:
		"attack","idle":
			ally_sprite.position = Vector2(-20,-90) if ally_sprite.flip_h else Vector2(20,-90)
		"die":
			ally_sprite.position = Vector2(75,-100) if ally_sprite.flip_h else Vector2(-80,-100)
		"far_attack":
			ally_sprite.position = Vector2(25,-105) if ally_sprite.flip_h else Vector2(-25,-105)
		"move":
			ally_sprite.position = Vector2(0,-100)
		"heal":
			ally_sprite.position = Vector2(0,-90) if ally_sprite.flip_h else Vector2(-5,-90)
	pass


func frame_changed():
	if ally_sprite.animation == "attack" and ally_sprite.frame == 15:
		cause_damage()
	if ally_sprite.animation == "far_attack" and ally_sprite.frame == 15:
		far_attack_frame()
		AudioManager.instance.shoot_audio_1.play()
	if ally_sprite.animation == "heal":
		if ally_sprite.frame == 11:
			heal_animation_player.play("Appear")
		if ally_sprite.frame == 19:
			var heal_data: int = skill3_heal_data_list[soldier_skill_levels[2]-1]
			for body in heal_area.get_overlapping_bodies():
				var ally: Ally = body.owner
				ally.current_data.heal(heal_data)
				var heal_buff: HealBuff = medical_buff_scene.instantiate()
				heal_buff.buff_level = soldier_skill_levels[2]
				ally.buffs.add_child(heal_buff)
	pass


func on_normal_attack_hit(target_enemy):
	if soldier_skill_levels[0] > 0:
		var duration: float = skill1_buff_duration_list[soldier_skill_levels[0]-1]
		var plugin_buff: DotBuff = medical_plague_buff_scene.instantiate()
		plugin_buff.buff_level = soldier_skill_levels[0]
		plugin_buff.duration = duration
		target_enemy.buffs.add_child(plugin_buff)
	pass


func _on_passive_heal_timer_timeout() -> void:
	if ally_state != AllyState.DIE:
		for body in heal_area.get_overlapping_bodies():
			var ally: Ally = body.owner
			if ally == self: continue
			if ally is MedicalSoldier: continue
			ally.current_data.heal(passive_heal_data)
			var heal_effect: HealBuff = passive_heal_effect_scene.instantiate()
			ally.buffs.add_child(heal_effect)
	pass # Replace with function body.


func soldier_skill_level_up(skill_id: int, skill_level: int):
	super(skill_id,skill_level)
	if skill_id == 0 and ally_sprite.sprite_frames != BLOOD_SOLDIERRES:
		var current_animation: String = ally_sprite.animation
		var current_frame: int = ally_sprite.frame
		ally_sprite.sprite_frames = BLOOD_SOLDIERRES
		ally_sprite.play(current_animation)
		ally_sprite.frame == current_frame
	if skill_id == 1:
		start_data.far_damage_range = 300
		current_data.update_far_attack_range()
		#far_attack_area.scale = Vector2.ONE * float(current_data.far_damage_range) / 100
		start_data.far_attack_speed = 1.5
		current_data.update_far_damage_speed()
		#far_attack_timer.wait_time = current_data.far_attack_speed
		#var shape: CollisionShape2D = far_attack_area.get_child(0)
		#shape.disabled = false
		
		var damage_block: DamageBlock = skill2_far_damage_list[soldier_skill_levels[1]-1]
		start_data.far_damage_low = damage_block.damage_low
		start_data.far_damage_high = damage_block.damage_high
		current_data.update_far_damage()
	pass


func summon_bullet(bullet_scene: PackedScene,summon_pos: Vector2, target_pos: Vector2, damage: int, damage_type: DataProcess.DamageType) -> Bullet:
	var bullet: Bullet = super(bullet_scene,summon_pos,target_pos,damage,damage_type)
	bullet.bullet_special_tag_levels["plugin"] = soldier_skill_levels[1]
	
	return bullet
	pass


func idle_process():
	if soldier_skill_levels[2] > 0 and skill_heal_timer.is_stopped() and current_data.health <= 100:
		translate_to_new_state(AllyState.SPECIAL)
		ally_sprite.play("heal")
		skill_heal_timer.start()
		heal_audio.play()
		return
	super()
	pass


func battle():
	if ally_sprite.animation == "idle":
		if soldier_skill_levels[2] > 0 and skill_heal_timer.is_stopped() and current_data.health <= 100:
			translate_to_new_state(AllyState.SPECIAL)
			ally_sprite.play("heal")
			skill_heal_timer.start()
			heal_audio.play()
			return
	super()
	pass


func skill_initialize():
	if soldier_skill_levels[0] > 0:
		soldier_skill_level_up(0,soldier_skill_levels[0])
	if soldier_skill_levels[1] > 0:
		soldier_skill_level_up(1,soldier_skill_levels[1])
	pass
