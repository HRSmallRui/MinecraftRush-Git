extends Enemy

@export var sprint_damage: int

@onready var sprint_sprite: AnimatedSprite2D = $UnitBody/SprintSprite
@onready var sprint_timer: Timer = $SprintTimer
@onready var sprint_continue_timer: Timer = $SprintContinueTimer
@onready var sprint_audio: AudioStreamPlayer = $SprintAudio
@onready var sprint_hit_area: Area2D = $UnitBody/SprintHitArea

var is_skill_releasing: bool = false


func _ready() -> void:
	super()
	sprint_sprite.hide()
	pass


func anim_offset():
	match enemy_sprite.animation:
		"attack","idle":
			enemy_sprite.position = Vector2(-5,-115) if enemy_sprite.flip_h else Vector2(0,-115)
		"die":
			enemy_sprite.position = Vector2(-30,-85) if enemy_sprite.flip_h else Vector2(30,-85)
		"far_attack":
			enemy_sprite.position = Vector2(-5,-120) if enemy_sprite.flip_h else Vector2(5,-120)
		"move_back":
			enemy_sprite.position = Vector2(0,-85)
		"move_front":
			enemy_sprite.position = Vector2(0,-90)
		"move_normal":
			enemy_sprite.position = Vector2(5,-95) if enemy_sprite.flip_h else Vector2(-10,-95)
	pass


func frame_changed():
	if enemy_sprite.animation == "attack" and enemy_sprite.frame == 14:
		cause_damage()
	if enemy_sprite.animation == "far_attack" and enemy_sprite.frame == 22:
		var summon_pos: Vector2 = far_attack_marker_flip.global_position if enemy_sprite.flip_h else far_attack_marker.global_position
		var damage: int = randi_range(current_data.far_damage_low,current_data.far_damage_high)
		var bullet: Bullet = summon_bullet(far_attack_bullet_scene,summon_pos,far_attack_position,damage,DataProcess.DamageType.PhysicsDamage)
		Stage.instance.bullets.add_child(bullet)
		AudioManager.instance.play_fork_throw_audio()
	pass


func _process(delta: float) -> void:
	super(delta)
	sprint_sprite.global_rotation = direction_sprite.global_rotation
	pass


func move_logic_process():
	if enemy_state == EnemyState.MOVE:
		if can_sprint() and silence_layers <= 0 and sprint_timer.is_stopped() and is_raining():
			if get_remaining_progress() > 900:
				sprint()
				is_skill_releasing = true
				return
	super()
	pass


func sprint():
	sprint_timer.start()
	interceptable = false
	sprint_audio.play()
	enemy_sprite.hide()
	sprint_sprite.show()
	sprint_hit_area.monitoring = true
	sprint_continue_timer.start()
	var original_speed = start_data.unit_move_speed
	start_data.unit_move_speed *= 5
	current_data.update_move_speed()
	stop_far_attack_translation = true
	
	await sprint_continue_timer.timeout
	stop_far_attack_translation = false
	sprint_timer.start()
	interceptable = true
	enemy_sprite.show()
	sprint_sprite.hide()
	sprint_hit_area.monitoring = false
	start_data.unit_move_speed = original_speed
	current_data.update_move_speed()
	is_skill_releasing = false
	pass


func _on_sprint_hit_area_area_entered(area: Area2D) -> void:
	var ally: Ally = area.owner
	ally.take_damage(sprint_damage,DataProcess.DamageType.PhysicsDamage,0,false,self)
	pass # Replace with function body.


func die(explosion: bool = false):
	super(explosion)
	sprint_continue_timer.stop()
	sprint_sprite.hide()
	enemy_sprite.show()
	pass


func can_sprint() -> bool:
	var enemy_path: EnemyPath = get_parent()
	var curve: Curve2D = enemy_path.curve
	for body in far_attack_area.get_overlapping_bodies():
		var ally: Ally = body.owner
		var ally_progress: float = curve.get_closest_offset(ally.position)
		if ally_progress > progress: return true
	return false


func is_raining() -> bool:
	if RainSystem.instance == null:
		return false
	else:
		return RainSystem.instance.current_rain_step >= RainSystem.RainStep.Small
