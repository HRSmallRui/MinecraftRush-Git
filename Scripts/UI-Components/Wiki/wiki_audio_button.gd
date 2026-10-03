extends TextureButton

@export var audio_stream: AudioStream

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	audio_stream_player.stream = audio_stream
	pass


func _on_pressed() -> void:
	if audio_stream_player.playing:
		audio_stream_player.stop()
	else:
		audio_stream_player.play()
	pass # Replace with function body.
