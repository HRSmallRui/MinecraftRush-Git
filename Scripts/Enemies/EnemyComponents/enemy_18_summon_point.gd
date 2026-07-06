extends Node2D

@export var enemy_scene: PackedScene
@export var linked_path: EnemyPath
@export var summon_list: Array[SummonWaveBlock]

@onready var appear_sprite: AnimatedSprite2D = $AppearSprite

var progress: float


func _ready() -> void:
	appear_sprite.hide()
	var curve: Curve2D = linked_path.curve
	position = curve.get_closest_point(position)
	progress = curve.get_closest_offset(position)
	
	Stage.instance.wave_summon.connect(on_wave_summon)
	pass


func summon_enemy():
	appear_sprite.show()
	appear_sprite.play("appear")
	await appear_sprite.animation_finished
	var enemy: Enemy = enemy_scene.instantiate()
	enemy.progress = progress
	linked_path.add_child(enemy)
	await get_tree().process_frame
	appear_sprite.hide()
	pass


func _on_timer_timeout() -> void:
	if appear_sprite.visible and appear_sprite.frame < 18:
		EffectManager.instance.play_block_effect(position,Vector2.ONE * 0.5, Color(0.3,0.1,0.07))
	pass # Replace with function body.


func on_wave_summon(wave_count: int):
	var wave_block: SummonWaveBlock = summon_list[wave_count-1]
	if wave_block == null: return
	for summon_block in wave_block.summon_list:
		if Stage.instance.is_win: return
		if summon_block is WaitTimeBlock:
			await get_tree().create_timer(summon_block.wait_time,false).timeout
		else:
			for i in summon_block.summon_count:
				if Stage.instance.is_win: return
				summon_enemy()
				await get_tree().create_timer(summon_block.time_interval,false).timeout
	pass
