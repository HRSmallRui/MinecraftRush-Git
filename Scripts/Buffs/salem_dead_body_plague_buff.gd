extends BuffClass

@export var spread_buff_scene: PackedScene
@export_file("*.tscn") var salem_plague_buff_scene_path: String
#@export var salem_plague_buff_scene: PackedScene
@export var explosion_damage_list: Array[IntSaver]
#@export var extra_plague_layer_count: IntSaver
@export var dead_body_buff_duration: FloatSaver

@onready var explosion_area: Area2D = $ExplosionArea

var enemy: Enemy

var passive_level: int
var dead_explosion_level: int


func buff_start():
	super()
	enemy = unit as Enemy
	pass


func remove_buff():
	super()
	if enemy.enemy_state == Enemy.EnemyState.DIE:
		on_enemy_died()
	pass


func on_enemy_died():
	var explosion_damage: int = explosion_damage_list[buff_level-1].saving_int_value
	
	AudioManager.instance.play_explosion_audio()
	EffectManager.instance.play_explosion_effect(global_position,Vector2.ONE,Color.DARK_GREEN)
	
	for body in explosion_area.get_overlapping_bodies():
		var now_enemy: Enemy = body.owner
		if now_enemy == enemy: continue
		var plauge_buff_scene: PackedScene = load(salem_plague_buff_scene_path)
		for i in 2:
			var plague_buff: DotBuff = plauge_buff_scene.instantiate()
			plague_buff.set("passive_level",passive_level)
			plague_buff.set("dead_explosion_level",dead_explosion_level)
			now_enemy.buffs.add_child(plague_buff)
		now_enemy.take_damage(explosion_damage,DataProcess.DamageType.ExplodeDamage,0)
	
	var spread_buff: BuffClass = spread_buff_scene.instantiate()
	spread_buff.duration = dead_body_buff_duration.saving_float_value
	spread_buff.set("passive_level",passive_level)
	spread_buff.set("dead_explosion_level",dead_explosion_level)
	enemy.buffs.add_child(spread_buff)
	pass
