extends TextureButton

@export var audio_stream: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	audio_stream_player.stream = audio_stream
	button_down.connect(on_button_down)
	button_up.connect(on_button_up)
	pass


func _on_pressed() -> void:
	if audio_stream_player.playing:
		audio_stream_player.stop()
	else:
		audio_stream_player.play()
	pass # Replace with function body.


func on_button_down():
	WikiManager.instance.scroll_locked = true
	pass


func on_button_up():
	WikiManager.instance.scroll_locked = false
	pass
