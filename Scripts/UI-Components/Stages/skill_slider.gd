extends HSlider
class_name SkillSlider

signal skill_level_changed(skill_level: int, skill_id: int)

@export var skill_name: String
@export var skill_id: int

@onready var skill_name_label: Label = $SkillNameLabel
@onready var level_label: Label = $LevelLabel


func _ready() -> void:
	value = max_value
	skill_name_label.text = skill_name
	pass


@warning_ignore("shadowed_variable_base_class")
func _on_value_changed(value: float) -> void:
	level_label.text = "LV. " + str(value) + " / " + str(max_value)
	skill_level_changed.emit(value, skill_id)
	pass # Replace with function body.
