extends Control
class_name BedUI

@export var hero_head_texture_list: Array[Texture2D]
@export var stage_view_texture_list: Array[Texture2D]

@onready var back_button: Button = $BackButton
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hero_texture: TextureButton = $SelectHeroUI/HeroTexture
@onready var click_audio: AudioStreamPlayer = $ClickAudio
@onready var hero_scroll_container: ScrollContainer = $SelectHeroUI/HeroScrollContainer
@onready var disable_hero: CheckBox = $SelectHeroUI/DisableHero
@onready var stage_texture: TextureRect = $StageSelectUI/StageTexture

var digital_saver: DigitalFightingSaver


func _init() -> void:
	digital_saver = DigitalFightingSaver.get_digital_fighting_saver()
	if digital_saver == null:
		digital_saver = DigitalFightingSaver.new()
		DigitalFightingSaver.save_digital_fighting_saver(digital_saver)
	pass


func _ready() -> void:
	update_hero_texture()
	update_hero_ban_status()
	update_stage_texture()
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
	update_hero_texture()
	hero_scroll_container.hide()
	click_audio.play(0.2)
	pass # Replace with function body.


func _on_hero_texture_pressed() -> void:
	hero_scroll_container.visible = !hero_scroll_container.visible
	click_audio.play(0.2)
	pass # Replace with function body.


func _on_disable_hero_button_pressed() -> void:
	hero_scroll_container.hide()
	digital_saver.ban_hero = ! digital_saver.ban_hero
	update_hero_ban_status()
	pass # Replace with function body.


func update_hero_ban_status():
	disable_hero.button_pressed = digital_saver.ban_hero
	hero_texture.disabled = digital_saver.ban_hero
	hero_texture.modulate = Color.DIM_GRAY if hero_texture.disabled else Color.WHITE
	pass


func _exit_tree() -> void:
	DigitalFightingSaver.save_digital_fighting_saver(digital_saver)
	pass


func update_stage_texture():
	stage_texture.texture = stage_view_texture_list[digital_saver.select_map_id]
	pass


func _on_left_button_pressed() -> void:
	digital_saver.select_map_id -= 1
	if digital_saver.select_map_id < 0:
		digital_saver.select_map_id = stage_view_texture_list.size()-1
	update_stage_texture()
	click_audio.play(0.2)
	pass # Replace with function body.


func _on_right_button_pressed() -> void:
	digital_saver.select_map_id += 1
	if digital_saver.select_map_id >= stage_view_texture_list.size():
		digital_saver.select_map_id = 0
	update_stage_texture()
	click_audio.play(0.2)
	pass # Replace with function body.
