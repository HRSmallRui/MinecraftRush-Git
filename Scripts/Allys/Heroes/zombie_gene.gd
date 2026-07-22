extends Hero

@export_group("Skill1")
@export var skill1_damage_block: DamageBlock
@export var freeze_buff_scene: PackedScene
@export var delay_slash_effect_scene: PackedScene
@export var slash_effect_scene: PackedScene
@export_group("Skill2")
@export_range(0,1,0.01) var defence_possible: float
@export_range(0,1,0.01) var defence_immune_rate: float
@export_range(0,1,0.01) var defence_damage_rate: float
@export_group("Skill3")
@export var skill3_damage: int
@export var sword_effect_scene: PackedScene
#@export var super_attack_marker_list: Array[Marker2D]

@onready var skill_1_timer: Timer = $Skill1Timer
@onready var skill_3_timer: Timer = $Skill3Timer
@onready var skill_3_attack_area: Area2D = $UnitBody/Skill3AttackArea
@onready var defence_audio: AudioStreamPlayer = $DefenceAudio
@onready var skill_1_condition_area: Area2D = $UnitBody/Skill1ConditionArea
@onready var skill_1_area: Area2D = $Skill1Area
@onready var slash_audio: AudioStreamPlayer = $SlashAudio
@onready var skill_3_release_audio: AudioStreamPlayer = $Skill3ReleaseAudio
@onready var skill_3_audio: AudioStreamPlayer = $Skill3Audio

var target_enemy_path: EnemyPath
var move_to_start_point: bool
var freeze_enemy_list: Array[Enemy]
var freeze_buff_list: Array[BuffClass]
var delay_slash_effect_list: Array[Node2D]
var skill1_origin_position: Vector2


func anim_offset():
	match ally_sprite.animation:
		"attack","idle":
			ally_sprite.position = Vector2(0,-110) if ally_sprite.flip_h else Vector2(5,-110)
		"defence":
			ally_sprite.position = Vector2(-10,-80) if ally_sprite.flip_h else Vector2(10,-80)
		"die":
			ally_sprite.position = Vector2(35,-115) if ally_sprite.flip_h else Vector2(-35,-115)
		"move":
			ally_sprite.position = Vector2(-30,-95) if ally_sprite.flip_h else Vector2(30,-95)
		"rebirth":
			ally_sprite.position = Vector2(-50,-165) if ally_sprite.flip_h else Vector2(50,-165)
		"skill1_end":
			ally_sprite.position = Vector2(25,-50) if ally_sprite.flip_h else Vector2(-25,-50)
		"skill1_start":
			ally_sprite.position = Vector2(-70,-60) if ally_sprite.flip_h else Vector2(70,-60)
		"skill3_end","skill3_start":
			ally_sprite.position = Vector2(-30,-155) if ally_sprite.flip_h else Vector2(30,-155)
	pass


func frame_changed():
	if ally_sprite.animation == "attack" and ally_sprite.frame == 14:
		cause_damage()
	
	if ally_sprite.animation == "skill1_start" :
		if ally_sprite.frame == 14:
			var target_pos: Vector2 = position
			skill1_origin_position = position
			target_pos.x += -50 if ally_sprite.flip_h else 50
			create_tween().tween_property(self,"position",target_pos,0.4)
			create_tween().tween_property(self,"modulate:a",0,0.4)
		if ally_sprite.frame == 22:
			ally_sprite.pause()
			delay_slash()
			skill_3_release_audio.play()
	if ally_sprite.animation == "skill1_end" and ally_sprite.frame == 33:
		body_collision.disabled = false
		hurt_box.set_collision_layer_value(4,true)
		for buff in  freeze_buff_list:
			if buff != null: buff.remove_buff()
		freeze_buff_list.clear()
		
		for delay_slash_effect in delay_slash_effect_list:
			if delay_slash_effect == null: continue
			delay_slash_effect.queue_free()
		delay_slash_effect_list.clear()
		
		for enemy in freeze_enemy_list:
			if enemy == null: continue
			var damage: int = randi_range(skill1_damage_block.damage_low,skill1_damage_block.damage_high)
			enemy.take_damage(damage,DataProcess.DamageType.TrueDamage,0,false,null,true,true)
			var red_slash_effect: Node2D = slash_effect_scene.instantiate()
			red_slash_effect.position = enemy.hurt_box.global_position
			red_slash_effect.scale *= 0.5
			Stage.instance.bullets.add_child(red_slash_effect)
		freeze_enemy_list.clear()
		slash_audio.play()
	
	if ally_sprite.animation == "skill3_start" and ally_sprite.frame == 29:
		ally_sprite.pause()
		skill3_release()
		await get_tree().create_timer(0.5,false).timeout
		if ally_state != AllyState.DIE: ally_sprite.play("skill3_end")
	pass


func take_damage(damage: int, damage_type: DataProcess.DamageType, broken_rate: float, far_attack: bool = false, source: Node2D = null,explosion: bool = false,aoe_attack: bool = false, deadly: bool = true) -> bool:
	var current_damage: int = damage
	var is_defence: bool
	if source != null and randf() < defence_possible and (ally_state != AllyState.SPECIAL and ally_state != AllyState.DIE):
		if source is Enemy:
			current_damage = float(damage) * (1-defence_immune_rate)
			is_defence = true
			#print(current_damage)
	var result: bool = super(current_damage,damage_type,broken_rate,far_attack,source,explosion,aoe_attack,deadly)
	if is_defence and ally_state != AllyState.DIE and current_intercepting_enemy != null:
		var enemy: Enemy = current_intercepting_enemy
		var return_damage: int = float(damage) * defence_damage_rate
		enemy.take_damage(return_damage,DataProcess.DamageType.TrueDamage,0,false)
		translate_to_new_state(AllyState.SPECIAL)
		ally_sprite.play("defence")
		defence_audio.play()
	return result


func idle_process():
	if skill_1_timer.is_stopped() and skill_1_condition_area.get_overlapping_bodies().size() >= 3:
		var enemy: Enemy = skill_1_condition_area.get_overlapping_bodies()[0].owner
		ally_sprite.flip_h = enemy.position.x < position.x
		translate_to_new_state(AllyState.SPECIAL)
		body_collision.disabled = true
		ally_sprite.play("skill1_start")
		skill_1_timer.start()
		return
	super()
	if ally_state == AllyState.IDLE:
		if skill_3_timer.is_stopped() and skill_3_attack_area.get_overlapping_bodies().size() >= 3:
			translate_to_new_state(AllyState.SPECIAL)
			ally_sprite.play("skill3_start")
			skill_3_timer.start()
			return
	pass


func delay_slash():
	freeze_enemy_list.clear()
	freeze_buff_list.clear()
	for body in skill_1_condition_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		freeze_enemy_list.append(enemy)
		var freeze_buff: BuffClass = freeze_buff_scene.instantiate()
		enemy.buffs.add_child(freeze_buff)
		freeze_buff_list.append(freeze_buff)
		var delay_slash_effect: Node2D = delay_slash_effect_scene.instantiate()
		delay_slash_effect.position = enemy.hurt_box.global_position
		Stage.instance.bullets.add_child(delay_slash_effect)
		delay_slash_effect.scale *= 0.4
		delay_slash_effect_list.append(delay_slash_effect)
	await get_tree().create_timer(0.4,false).timeout
	ally_sprite.play("skill1_end")
	var delta_pos: Vector2 = position - skill1_origin_position
	position = skill1_origin_position - delta_pos
	create_tween().tween_property(self,"position",skill1_origin_position,0.3)
	create_tween().tween_property(self,"modulate:a",1,0.3)
	pass


func skill3_release():
	skill_3_audio.play()
	for i in 40:
		var pos: Vector2= position + Vector2(randf_range(-208,0),randf_range(-145,145))
		var sword_effect: Node2D = sword_effect_scene.instantiate()
		sword_effect.position = pos
		sword_effect.scale *= 0.3
		var sword_effect2: Node2D = sword_effect_scene.instantiate()
		sword_effect2.position = pos
		sword_effect2.scale = sword_effect.scale
		sword_effect2.position.x +=  2 * (position.x - pos.x)
		Stage.instance.bullets.add_child(sword_effect)
		Stage.instance.bullets.add_child(sword_effect2)
		sword_effect.get_node("Cut/SwordSprite").rotation_degrees += randf_range(-15,0)
		sword_effect2.get_node("Cut/SwordSprite").rotation_degrees += randf_range(0,15)
		delay_free_sword_effect(sword_effect)
		delay_free_sword_effect(sword_effect2)
	for body in skill_3_attack_area.get_overlapping_bodies():
		var enemy: Enemy = body.owner
		enemy.take_damage(skill3_damage,DataProcess.DamageType.PhysicsDamage,0,false,null,true,true)
	pass


func battle():
	if ally_sprite.animation == "idle":
		if skill_3_timer.is_stopped() and skill_3_attack_area.get_overlapping_bodies().size() >= 3:
			translate_to_new_state(AllyState.SPECIAL)
			ally_sprite.play("skill3_start")
			skill_3_timer.start()
			return
		if skill_1_timer.is_stopped() and normal_attack_timer.is_stopped():
			normal_attack_timer.start()
			translate_to_new_state(AllyState.SPECIAL)
			skill_1_timer.start()
			ally_sprite.play("skill1_start")
			return
	super()
	pass


func delay_free_sword_effect(sword_effect: Node2D):
	await get_tree().create_timer(1.5,false).timeout
	var disappear_tween: Tween = create_tween()
	disappear_tween.tween_property(sword_effect,"modulate:a",0,0.6)
	await disappear_tween.finished
	sword_effect.queue_free()
	pass
