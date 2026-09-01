extends Stage

@export var sun_tip_button_scene: PackedScene


func wave_tip(wave_count: int):
	if wave_count == 2:
		await get_tree().create_timer(1,false).timeout
		var tip_button: TipButton = sun_tip_button_scene.instantiate()
		tips_container.add_child(tip_button)
	pass
