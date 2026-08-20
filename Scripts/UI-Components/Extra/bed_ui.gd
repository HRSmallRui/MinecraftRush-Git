extends Control
class_name BedUI

@export var hero_head_texture_list: Array[Texture2D]

@onready var back_button: Button = $BackButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hero_texture: TextureButton = $SelectHeroUI/HeroTexture
@onready var click_audio: AudioStreamPlayer = $ClickAudio
@onready var hero_scroll_container: ScrollContainer = $SelectHeroUI/HeroScrollContainer

var digital_saver: DigitalFightingSaver


func _init() -> void:
	digital_saver = DigitalFightingSaver.get_digital_fighting_saver()
	if digital_saver == null:
		digital_saver = DigitalFightingSaver.new()
		DigitalFightingSaver.save_digital_fighting_saver(digital_saver)
	pass


func _ready() -> void:
	update_hero_texture()
	pass


func _on_back_button_pressed() -> void:
	back()
	ExtraContent.instance.back()
	back_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pass # Replace with function body.


func back():
	animation_player.play_backwards("appear")
	await animation_player.animation_finished
	queue_free()
	pass


func _input(event: InputEvent) -> void:
	if ExtraContent.instance.can_control and event.is_action_released("escape"):
		back()
	pass


func update_hero_texture():
	hero_texture.texture_normal = hero_head_texture_list[digital_saver.hero_id]
	pass


func _on_hero_select_button_hero_select(select_id: int) -> void:
	digital_saver.hero_id = select_id
	DigitalFightingSaver.save_digital_fighting_saver(digital_saver)
	update_hero_texture()
	hero_scroll_container.hide()
	pass # Replace with function body.


func _on_hero_texture_pressed() -> void:
	hero_scroll_container.visible = !hero_scroll_container.visible
	pass # Replace with function body.
