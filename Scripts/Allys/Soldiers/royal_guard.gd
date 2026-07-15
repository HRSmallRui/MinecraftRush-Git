extends Soldier
class_name RoyalGuard

@export var SOLDIER_LV_4_1S: Texture
@export var ROYAL_GUARD_UPGRADE: SpriteFrames
@export_group("Skill1","skill1")
@export var skill1_damage_list: Array[DamageBlock]
@export_range(0,1,0.01) var skill1_release_possible: float
@export var skill1_kill_possible: float
@export_group("Skill2","skill2")
@export var skill2_defence_possible_near: float
@export var skill2_defence_possible_far: float
@export_group("Skill3","skill3")
@export var skill3_protection_buff_scene_list: Array[PackedScene]
@export var skill3_total_defence_rate_list: Array[float]

@onready var protection_area: Area2D = $UnitBody/ProtectionArea
@onready var protection_buff_timer: Timer = $ProtectionBuffTimer
@onready var defence_audio: AudioStreamPlayer = $DefenceAudio
@onready var skill_1_audio: AudioStreamPlayer = $Skill1Audio
@onready var skill_1_timer: Timer = $Skill1Timer


func anim_offset():
	if ally_sprite.animation == "die" or ally_sprite.animation == "skill1":
		match ally_sprite.animation:
			"die":
				ally_sprite.position = Vector2(75,-95) if ally_sprite.flip_h else Vector2(-75,-95)
			"skill1":
				ally_sprite.position = Vector2(25,-120) if ally_sprite.flip_h else Vector2(-25,-120)
	elif soldier_skill_levels[1] == 0:
		match ally_sprite.animation:
			"idle","attack":
				ally_sprite.position = Vector2(-5,-120) if ally_sprite.flip_h else Vector2(5,-120)
			"move":
				ally_sprite.position = Vector2(-15,-90) if ally_sprite.flip_h else Vector2(15,-90)
	else:
		match ally_sprite.animation:
			"idle","attack":
				ally_sprite.position = Vector2(-5,-120) if ally_sprite.flip_h else Vector2(5,-120)
			"defence":
				ally_sprite.position = Vector2(-5,-85) if ally_sprite.flip_h else Vector2(5,-85)
			"move":
				ally_sprite.position = Vector2(-15,-90) if ally_sprite.flip_h else Vector2(15,-90)
	pass


func frame_changed():
	if ally_sprite.animation == "attack" and ally_sprite.frame == 14:
		cause_damage()
	elif ally_sprite.animation == "skill1" and ally_sprite.frame == 15:
		royal_judege_damage()
	pass


func soldier_skill_level_up(skill_id: int, skill_level: int):
	super(skill_id,skill_level)
	if skill_id == 1:
		var current_animation: String = ally_sprite.animation
		ally_texture = SOLDIER_LV_4_1S
		var frame:int = ally_sprite.frame
		ally_sprite.sprite_frames = ROYAL_GUARD_UPGRADE
		ally_sprite.play(current_animation)
		ally_sprite.frame = frame
		start_data.armor += 0.05
		current_data.update_armor()
	elif skill_id == 2 and skill_level == 1:
		protection_buff_timer.start()
	if skill_id == 2:
		var total_defence_rate: float = skill3_total_defence_rate_list[soldier_skill_levels[2]-1]
		start_data.total_defence_rate = total_defence_rate
		current_data.update_total_defence_rate()
	pass


func _on_protection_buff_timer_timeout() -> void:
	for ally_body: UnitBody in protection_area.get_overlapping_bodies():
		var ally: Ally = ally_body.owner
		if ally is RoyalGuard or ally is Hero: continue
		var protection_buff: PropertyBuff = skill3_protection_buff_scene_list[soldier_skill_levels[2]-1].instantiate()
		ally.buffs.add_child(protection_buff)
	pass # Replace with function body.


func battle():
	if ally_sprite.animation == "idle" and normal_attack_timer.is_stopped() and skill_1_timer.is_stopped():
		if soldier_skill_levels[0] > 0:
			if randf_range(0,1) < skill1_release_possible:
				ally_sprite.play("skill1")
				normal_attack_timer.start()
				skill_1_timer.start()
				skill_1_audio.play()
	super()
	pass


func royal_judege_damage():
	if current_intercepting_enemy != null:
		if randf_range(0,1) < skill1_kill_possible and current_intercepting_enemy.enemy_type < Enemy.EnemyType.Super:
			TextEffect.text_effect_show("秒杀",TextEffect.TextEffectType.SecKill,current_intercepting_enemy.hurt_box.global_position + Vector2(0,-30))
			current_intercepting_enemy.sec_kill(true)
			Achievement.achieve_int_add("RoyalGuardSkill1",1,99)
		else:
			var damage: int = skill1_damage_list[soldier_skill_levels[0]-1].get_damage()
			TextEffect.text_effect_show("重击",TextEffect.TextEffectType.Barrack,current_intercepting_enemy.hurt_box.global_position + Vector2(0,-30))
			current_intercepting_enemy.take_damage(damage,DataProcess.DamageType.TrueDamage,0,false,self,false,false)
	pass


func take_damage(damage: int, damage_type: DataProcess.DamageType, broken_rate: float, far_attack: bool = false, source: Node2D = null,explosion: bool = false,aoe_attack: bool = false, deadly: bool = true) -> bool:
	if soldier_skill_levels[1] > 0 and source is Enemy:
		var enemy: Enemy = source
		var defence_possible: float = skill2_defence_possible_far if far_attack else skill2_defence_possible_near
		if defence_condition(enemy) and randf_range(0,1) < defence_possible:
			ally_sprite.play("defence")
			defence_audio.play()
			if far_attack: Achievement.achieve_int_add("RoyalGuardSkill2",1,2000)
			return false
	return super(damage,damage_type,broken_rate,far_attack,source,explosion,aoe_attack, deadly)
	pass


func defence_condition(attack_source: Enemy) -> bool:
	if attack_source.enemy_type < Enemy.EnemyType.Boss and ally_sprite.animation != "skill1":
		if ally_state == AllyState.IDLE or ally_state == AllyState.BATTLE:
			return true
	return false
	pass
