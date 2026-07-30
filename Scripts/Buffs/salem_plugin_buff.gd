extends DotBuff

@export var lower_damage_list: Array[int] = [1,2,3,4,5,6,7,8,9]
@export var higher_damage_list: Array[int] = [2,4,6,8,10,12,14,16,18]
#@export var spread_buff_scene: PackedScene
@export_file("*.tscn") var dead_body_buff_scene_path: String
@export var dead_body_buff_duration: FloatSaver
@export var explosion_damage_list: Array[int]
@export var salem_plague_duration: FloatSaver
@export var max_plague_layer_count: IntSaver

var passive_level: int
var dead_explosion_level: int

func buff_start() -> void:
	super()
	duration = salem_plague_duration.saving_float_value
	if passive_level == 1:
		dot_damage = lower_damage_list
	else:
		dot_damage = higher_damage_list
	var enemy: Enemy = unit
	if enemy.enemy_buff_tags.has("salem_plugin"):
		buff_level = clampi(enemy.enemy_buff_tags["salem_plugin"]+1,0,max_plague_layer_count.saving_int_value)
		enemy.enemy_buff_tags["salem_plugin"] = buff_level
	else:
		buff_level = 1
		enemy.enemy_buff_tags["salem_plugin"] = 1
	
	if dead_explosion_level > 0 and !enemy.enemy_buff_tags.has("salem_plague_dead_body"):
		var dead_body_buff_scene: PackedScene = load(dead_body_buff_scene_path)
		var dead_body_buff: BuffClass = dead_body_buff_scene.instantiate()
		dead_body_buff.duration = dead_body_buff_duration.saving_float_value
		dead_body_buff.set("passive_level",passive_level)
		dead_body_buff.set("dead_explosion_level",dead_explosion_level)
		enemy.buffs.add_child(dead_body_buff)
	pass
