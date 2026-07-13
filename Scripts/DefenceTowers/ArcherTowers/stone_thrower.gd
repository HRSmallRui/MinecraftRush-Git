extends Shooter

@export var black_stone_scene: PackedScene
@export var black_stone_damage_list: Array[DamageBlock]

@onready var skill_1_marker: Marker2D = $Skill1Marker


func skill1_release():
	shoot()
	play("skill1")
	pass


func frame_condition():
	super()
	if animation == "skill1" and frame == 19:
		shoot_audio_play()
		var enemy: Enemy
		if tower.target_list.size() > 0:
			enemy = tower.target_list[0]
		elif tower.last_target != null:
			enemy = tower.last_target
		else: return
		
		flip_h = enemy.position.x < global_position.x
		var before_frame = frame
		if enemy.position.y < tower.position.y: play("shoot_back")
		else: play("shoot_front")
		frame = before_frame
		
		var summon_pos: Vector2
		if animation == "shoot_front":
			summon_pos = front_flip.global_position if flip_h else front_no_flip.global_position
		elif animation == "shoot_back":
			summon_pos = back_flip.global_position if flip_h else back_no_flip.global_position
		var target_pos: Vector2 = enemy.hurt_box.global_position + enemy.direction * enemy.current_data.unit_move_speed * 2
		
		var bullet: Bullet = summon_bullet(summon_pos,target_pos,black_stone_scene)
		var damage_block: DamageBlock = black_stone_damage_list[tower.tower_skill_levels[0]-1]
		bullet.damage = damage_block.get_damage()
	pass


func summon_bullet(summon_pos: Vector2, target_pos: Vector2, bullet_scene: PackedScene = arrow_scene) -> Bullet:
	var bullet = super(summon_pos,target_pos,bullet_scene)
	if tower.tower_skill_levels[1] > 0:
		bullet.bullet_special_tag_levels["stone_explosion"] = tower.tower_skill_levels[1]
	return bullet
	pass
