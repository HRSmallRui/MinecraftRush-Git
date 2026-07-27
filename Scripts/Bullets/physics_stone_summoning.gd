extends ShooterBullet

@export var stone_bullet_scene: PackedScene
@export var stone_explosion_effect_scene: PackedScene
@export var stone_explosion_damage_list: Array[DamageBlock]
@export var extra_stone_damage_rate: FloatSaver

@onready var condition_area: Area2D = $ConditionArea
@onready var explosion_hit_area: Area2D = $ExplosionHitArea

var has_exploded: bool


func _ready() -> void:
	super()
	move_finshed.connect(on_move_finished)
	pass


func enemy_take_damage(enemy: Enemy):
	super(enemy)
	for hurt_box in condition_area.get_overlapping_areas():
		var new_enemy = hurt_box.owner
		if new_enemy == enemy: continue
		var stone_bullet: Bullet = stone_bullet_scene.instantiate()
		stone_bullet.position = position
		stone_bullet.erase_enemy_list.append(enemy)
		stone_bullet.damage = extra_stone_damage_rate.saving_float_value * damage
		var target_pos:Vector2 = hurt_box.global_position
		target_pos += new_enemy.direction * new_enemy.current_data.unit_move_speed * 2
		stone_bullet.target_position = target_pos
		if bullet_special_tag_levels.has("stone_explosion"):
			stone_bullet.bullet_special_tag_levels["stone_explosion"] = bullet_special_tag_levels["stone_explosion"]
		Stage.instance.bullets.add_child(stone_bullet)
		return
	on_move_finished()
	
	pass


func on_move_finished():
	hide()
	if bullet_special_tag_levels.has("stone_explosion") and !has_exploded:
		has_exploded = true
		EffectManager.instance.play_sprite_effect(stone_explosion_effect_scene,position)
		AudioManager.instance.stone_explosion_audio.play()
		var damage_block: DamageBlock = stone_explosion_damage_list[bullet_special_tag_levels["stone_explosion"]-1]
		var total_damage: int
		for box in explosion_hit_area.get_overlapping_areas():
			var new_enemy: Enemy = box.owner
			var origin_health: int = new_enemy.current_data.health
			new_enemy.take_damage(damage_block.get_damage(),DataProcess.DamageType.PhysicsDamage,0,false,source,explosion,true)
			total_damage += origin_health - new_enemy.current_data.health
		Achievement.achieve_int_add("ExplosionStone",total_damage,1200)
	pass
