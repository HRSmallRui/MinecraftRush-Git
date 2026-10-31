@tool
extends VBoxContainer

@export var update: bool:
	set(v):
		call_deferred("update_property")
@export_range(0,100,1,"or_greater") var level_max: int:
	set(v):
		level_max = v
		call_deferred("on_level_max_set")
@export var level_offset: int = 0

@export var unit_list: Array[UnitData]
@export var heal_speed_list: Array[int]

@export_group("AttackGroup")
@export var near_damage_type: DataProcess.DamageType = DataProcess.DamageType.PhysicsDamage:
	set(v):
		near_damage_type = v
		call_deferred("on_damage_type_changed")
@export var far_attack_show: bool = false:
	set(v):
		far_attack_show = v
		call_deferred("on_far_attack_visible_update")
@export var far_damage_type: DataProcess.DamageType = DataProcess.DamageType.PhysicsDamage:
	set(v):
		far_damage_type = v
		call_deferred("on_damage_type_changed")

@export_group("Others")
@export var rebirth_time: float
@export var intercepting_range: int



@export_group("OtherConfig")
@export var far_attack_part: Array[PanelContainer]
@export var near_damage_type_icons: Array[Texture2D]
@export var far_damage_type_icons: Array[Texture2D]

@onready var level_label: Label = $CenterContainer/HBoxContainer/LevelLabel
@onready var level_slider: HSlider = $CenterContainer/HBoxContainer/LevelSlider
@onready var health_label: Label = $WikiTable/WikiTableElement2/HealthLabel
@onready var heal_speed_label: Label = $WikiTable/WikiTableElement4/HealSpeedLabel
@onready var near_damage_icon: TextureRect = $WikiTable/WikiTableElement5/NearDamageIcon
@onready var near_damage_label: Label = $WikiTable/WikiTableElement6/NearDamageLabel
@onready var near_damage_speed_label: Label = $WikiTable/WikiTableElement8/NearDamageSpeedLabel
@onready var far_damage_icon: TextureRect = $WikiTable/WikiTableElement19/FarDamageIcon
@onready var far_damage_label: Label = $WikiTable/WikiTableElement20/FarDamageLabel
@onready var far_damage_range_label: Label = $WikiTable/WikiTableElement22/FarDamageRangeLabel
@onready var far_damage_speed_label: Label = $WikiTable/WikiTableElement24/FarDamageSpeedLabel
@onready var armor_label: Label = $WikiTable/WikiTableElement10/ArmorLabel
@onready var magic_defence_label: Label = $WikiTable/WikiTableElement12/MagicDefenceLabel
@onready var move_speed_label: Label = $WikiTable/WikiTableElement14/MoveSpeedLabel
@onready var rebirth_label: Label = $WikiTable/WikiTableElement16/RebirthLabel
@onready var intercepting_range_label: Label = $WikiTable/WikiTableElement18/InterceptingRangeLabel


func _ready() -> void:
	update_property(1)
	pass


func on_level_max_set():
	var parama: int = level_max
	heal_speed_list.resize(parama)
	unit_list.resize(parama)
	level_slider.max_value = parama
	pass


func _on_level_slider_drag_started() -> void:
	WikiManager.instance.scroll_locked = true
	pass # Replace with function body.


func _on_level_slider_drag_ended(value_changed: bool) -> void:
	WikiManager.instance.scroll_locked = false
	pass # Replace with function body.


func _on_level_slider_value_changed(value: float) -> void:
	
	update_property(level_slider.value)
	pass # Replace with function body.


func on_far_attack_visible_update():
	for panel in far_attack_part:
		panel.visible = far_attack_show
	pass


func on_damage_type_changed():
	near_damage_icon.texture = near_damage_type_icons[near_damage_type]
	far_damage_icon.texture = far_damage_type_icons[far_damage_type]
	pass


func update_property(level: int = level_slider.value):
	level_label.text = "LV." + str(level + level_offset)
	var unit: UnitData = unit_list[level-1]
	health_label.text = str(unit.health)
	heal_speed_label.text = str(heal_speed_list[level-1]) + " /秒"
	near_damage_label.text = str(unit.near_damage_low) + " - " + str(unit.near_damage_high)
	near_damage_speed_label.text = str(unit.near_attack_speed) + " 秒"
	far_damage_label.text = str(unit.far_damage_low) + " - " + str(unit.far_damage_high)
	far_damage_speed_label.text = str(unit.far_attack_speed) + " 秒"
	far_damage_range_label.text = str(unit.far_damage_range)
	armor_label.text = str(int(unit.armor * 100))
	magic_defence_label.text = str(int(unit.magic_defence * 100))
	move_speed_label.text = str(unit.unit_move_speed)
	rebirth_label.text = str(rebirth_time) + " 秒"
	intercepting_range_label.text = str(intercepting_range)
	pass
