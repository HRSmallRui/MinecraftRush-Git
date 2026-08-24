extends CanvasLayer
class_name DigitalFightingEndUI

@export_file("*.tscn") var back_path: String

var enemy_total_count: int
var enemy_pass_count: int
var enemy_kill_count: int
var total_caused_damage: int

@onready var end_label: Label = $Button/Panel/EndLabel


func _ready() -> void:
	get_tree().paused = true
	
	end_label.text = "敌人总数：" + str(enemy_total_count) + "\n"
	end_label.text += "杀敌数量：" + str(enemy_kill_count) + "\n"
	end_label.text += "通过数量：" + str(enemy_pass_count) + "\n"
	end_label.text += "总输出伤害：" + str(total_caused_damage)
	pass


func _on_finish_button_pressed() -> void:
	Global.change_scene(back_path)
	pass # Replace with function body.


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	pass # Replace with function body.


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and !$AnimationPlayer.is_playing():
		_on_finish_button_pressed()
	pass
