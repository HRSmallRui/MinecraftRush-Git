extends Stage

@export var rain_system: RainSystem
@export var rain_tip_button_scene: PackedScene


func win(wait_time: float = 6):
	super(wait_time)
	await get_tree().create_timer(2,false).timeout
	rain_system.translate_to_rain_step(RainSystem.RainStep.None)
	pass


func wave_tip(wave_count: int):
	if wave_count == 3:
		await get_tree().create_timer(1,false).timeout
		var tip_button: TipButton = rain_tip_button_scene.instantiate()
		tips_container.add_child(tip_button)
	pass
