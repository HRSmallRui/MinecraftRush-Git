extends DotBuff

@export_file("*.tscn") var plague_buff_scene_path: String

@onready var explosion_area: Area2D = $ExplosionArea
@onready var plugin_explosion: AudioStreamPlayer = $PluginExplosion
@onready var plugin_effect: Sprite2D = $PluginEffect

var has_explosion: bool
var enemy: Enemy


func remove_buff():
	plugin_effect.hide()
	if unit is Enemy:
		var enemy: Enemy = unit
		if enemy.enemy_state == Enemy.EnemyState.DIE and !enemy.is_disappear_killing and !has_explosion:
			has_explosion = true
			EffectManager.instance.play_explosion_effect(enemy.hurt_box.global_position,Vector2.ONE*0.5,Color.DARK_RED,0)
			plugin_explosion.play()
			var enemy_list: Array[Enemy]
			for body in explosion_area.get_overlapping_bodies():
				var new_enemy: Enemy = body.owner
				enemy_list.append(new_enemy)
			for new_enemy in enemy_list:
				if new_enemy == self: continue
				new_enemy.take_damage(30,DataProcess.DamageType.TrueDamage,0,false,null,false,true,)
			for new_enemy in enemy_list:
				#if new_enemy.enemy_state == Enemy.EnemyState.DIE: continue
				var dot_debuff: DotBuff = load(plague_buff_scene_path).instantiate()
				dot_debuff.duration = duration
				dot_debuff.buff_level = buff_level
				new_enemy.buffs.add_child(dot_debuff)
			await plugin_explosion.finished
	super()
	pass


func buff_start():
	enemy = unit
	plugin_effect.global_position = enemy.hurt_box.global_position
	Achievement.achieve_int_add("PluginPeople",1,1000)
	pass


func _buff_process(delta: float):
	super(delta)
	plugin_effect.global_position = enemy.hurt_box.global_position
	pass
