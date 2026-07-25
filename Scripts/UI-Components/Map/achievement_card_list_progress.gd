extends AchiementCard

@export var key_list: Array[String]

@onready var progress_bar: TextureProgressBar = $ProgressBar
@onready var progress_label: Label = $ProgressLabel


func compelete_state():
	super()
	progress_bar.hide()
	progress_label.hide()
	pass


func locked_state():
	super()
	var sav: GameSaver = Global.get_game_sav()
	var current_value: int
	for key: String in key_list:
		if Achievement.get_achieve_temp().has(key): current_value += 1
	progress_bar.value = float(current_value) / key_list.size()
	progress_label.text = str(current_value) + " / " + str(key_list.size())
	pass
