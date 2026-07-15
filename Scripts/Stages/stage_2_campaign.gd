extends Stage

@export var battle_tip_scene: PackedScene
@export var barrack_tip_scene: PackedScene


func _ready() -> void:
	super()
	stage_sav.tower_unlock_sav[0][1] = true
	stage_sav.tower_unlock_sav[1][1] = true
	stage_sav.tower_unlock_sav[2][1] = true
	stage_sav.tower_unlock_sav[3][1] = true
	pass


func wave_tip(wave_count: int):
	match wave_count:
		1:
			tips_container.add_child(battle_tip_scene.instantiate())
		3:
			tips_container.add_child(barrack_tip_scene.instantiate())
	pass
