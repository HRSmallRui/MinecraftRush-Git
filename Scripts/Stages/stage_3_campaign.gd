extends Stage

@export var magic_defence_tip_scene: PackedScene
@export var fire_sprite_list: Array[AnimatedSprite2D]

@onready var explosion_marker: Marker2D = $ExplosionMarker


func _ready() -> void:
	super()
	for block: Array in stage_sav.tower_unlock_sav:
		block[2] = true
	for fire in fire_sprite_list:
		fire.hide()
	pass


func wave_tip(wave_count: int):
	match wave_count:
		7:
			tips_container.add_child(magic_defence_tip_scene.instantiate())
		9:
			await get_tree().create_timer(15,false).timeout
			EffectManager.instance.play_explosion_effect(explosion_marker.global_position,Vector2.ONE*3)
			EffectManager.instance.play_smoke_effect(explosion_marker.global_position,Vector2.ONE*3)
			AudioManager.instance.play_explosion_audio()
			stage_camera.position = explosion_marker.position
			for fire in fire_sprite_list:
				fire.show()
	pass


func tower_check():
	var tower_lv3_finished: Array[bool] = [false,false,false,false]
	for tower: DefenceTower in towers.get_children():
		if tower.tower_level >= 3:
			tower_lv3_finished[tower.tower_type] = true
			
	for value in tower_lv3_finished:
		if !value: return
	
	Achievement.achieve_complete("TowerLV3")
	
	pass
