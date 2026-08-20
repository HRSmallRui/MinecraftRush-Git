extends Button

enum UpgradeType{
	Archer,
	Barrack,
	Magic,
	Bombard,
	Firerain,
	Reinforcer
}

@export var upgrade_type: UpgradeType
@export var bed_ui: BedUI
@export var upgrade_texture: Texture2D

@onready var level_label: Label = $LevelLabel
@onready var texture_rect: TextureRect = $TextureRect

var upgrade_level: int:
	set(v):
		upgrade_level = v
		level_label.text = str(upgrade_level)


func _ready() -> void:
	texture_rect.texture = upgrade_texture
	upgrade_level = bed_ui.digital_saver.tech_level_list[upgrade_type]
	pass


func _pressed() -> void:
	upgrade_level += 1
	if upgrade_level > 5:
		upgrade_level = 0
	bed_ui.digital_saver.tech_level_list[upgrade_type] = upgrade_level
	pass
