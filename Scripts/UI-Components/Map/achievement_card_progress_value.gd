extends AchiementCard

@export var target_value: int

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var progress_label: Label = $ProgressLabel


func compelete_state():
	super()
	progress_bar.hide()
	progress_label.hide()
	pass


func locked_state():
	super()
	var sav: GameSaver = Global.get_game_sav()
	if sav.number_count_achievements.has(sav_keyword):
		var current_value: float = sav.number_count_achievements[sav_keyword]
		progress_bar.value = current_value / target_value
		progress_label.text = str(current_value) + " / " + str(target_value)
	pass
