@tool
extends VBoxContainer

@export var update: bool:
	set(v):
		call_deferred("on_update")
@export var linked_data: UnitData
@export var eternal_health: bool
@export var unknown_damage: bool
@export var damage_near_range: int = 0:
	set(v):
		damage_near_range = v
		call_deferred("set_panel_part_visible",near_damage_range_part,v != 0)
		call_deferred("on_update")
@export var lives_taken: int = 1
@export var enemy_bounty: int
@export var near_damage_type: DataProcess.DamageType:
	set(v):
		near_damage_type = v
		call_deferred("update_damage_type")
@export var far_damage_type: DataProcess.DamageType:
	set(v):
		far_damage_type = v
		call_deferred("update_damage_type")
@export var far_damage_show: bool:
	set(v):
		far_damage_show = v
		call_deferred("set_panel_part_visible",far_damage_part,v)
@export_group("ConstConfigs")
@export var near_damage_type_icons: Array[Texture2D]
@export var far_damage_type_icons: Array[Texture2D]
@export var near_damage_range_part: Array[PanelContainer]
@export var far_damage_part: Array[PanelContainer]
@export var explosion_defence_part: Array[PanelContainer]
@export var total_defence_part: Array[PanelContainer]
@export var difficulty_color: Array[Color]
@export var difficulty_rate_list: Array[float]

@onready var health_label: Label = $WikiTable/WikiTableElement2/HealthLabel
@onready var damage_near_icon: TextureRect = $WikiTable/WikiTableElement5/DamageNearIcon
@onready var damage_near_label: Label = $WikiTable/WikiTableElement6/DamageNearLabel
@onready var damage_near_speed_label: Label = $WikiTable/WikiTableElement8/DamageNearSpeedLabel
@onready var damage_near_range_label: Label = $WikiTable/WikiTableElement20/DamageNearRangeLabel
@onready var far_damage_icon: TextureRect = $WikiTable/WikiTableElement21/FarDamageIcon
@onready var far_damage_label: Label = $WikiTable/WikiTableElement22/FarDamageLabel
@onready var far_damage_speed_label: Label = $WikiTable/WikiTableElement24/FarDamageSpeedLabel
@onready var far_damage_range_label: Label = $WikiTable/WikiTableElement26/FarDamageRangeLabel
@onready var armor_label: Label = $WikiTable/WikiTableElement10/ArmorLabel
@onready var magic_defence_label: Label = $WikiTable/WikiTableElement12/MagicDefenceLabel
@onready var total_defence_label: Label = $WikiTable/WikiTableElement28/TotalDefenceLabel
@onready var explosion_defence_label: Label = $WikiTable/WikiTableElement30/ExplosionDefenceLabel
@onready var move_speed_label: Label = $WikiTable/WikiTableElement14/MoveSpeedLabel
@onready var lives_taken_label: Label = $WikiTable/WikiTableElement16/LivesTakenLabel
@onready var money_label: Label = $WikiTable/WikiTableElement18/MoneyLabel

@onready var difficulty_label: Label = $CenterContainer/HBoxContainer/DifficultyLabel
@onready var difficulty_slider: HSlider = $CenterContainer/HBoxContainer/DifficultySlider


func _ready() -> void:
	on_update()
	pass


func _on_difficulty_slider_drag_started() -> void:
	WikiManager.instance.scroll_locked = true
	pass # Replace with function body.


func _on_difficulty_slider_drag_ended(value_changed: bool) -> void:
	WikiManager.instance.scroll_locked = false
	pass # Replace with function body.


func _on_difficulty_slider_value_changed(value: float) -> void:
	update_health()
	pass # Replace with function body.


func on_update():
	update_health()
	damage_near_label.text = str(linked_data.near_damage_low) + " - " + str(linked_data.near_damage_high)
	damage_near_speed_label.text = str(linked_data.near_attack_speed) + " 秒"
	if linked_data.near_damage_low == 0 and linked_data.near_damage_high == 0:
		damage_near_label.text = "无"
		damage_near_speed_label.text = "无"
	damage_near_range_label.text = str(damage_near_range)
	far_damage_label.text = str(linked_data.far_damage_low) + " - " + str(linked_data.far_damage_high)
	far_damage_speed_label.text = str(linked_data.far_attack_speed) + " 秒"
	far_damage_range_label.text = str(linked_data.far_damage_range)
	armor_label.text = str(int(linked_data.armor * 100))
	magic_defence_label.text = str(int(linked_data.magic_defence * 100))
	explosion_defence_label.text = str(int(linked_data.explode_defence * 100))
	total_defence_label.text = str(linked_data.total_defence_rate * 100) + str("%")
	set_panel_part_visible(explosion_defence_part,linked_data.explode_defence > 0)
	set_panel_part_visible(total_defence_part,linked_data.total_defence_rate > 0)
	move_speed_label.text = str(linked_data.unit_move_speed)
	lives_taken_label.text = str(lives_taken)
	money_label.text = str(enemy_bounty)
	
	if eternal_health: health_label.text = "??"
	if unknown_damage: damage_near_label.text = "?? - ??"
	pass


func set_panel_part_visible(panel_group: Array[PanelContainer], is_visible: bool):
	for panel in panel_group:
		panel.visible = is_visible
	pass


func update_damage_type():
	damage_near_icon.texture = near_damage_type_icons[near_damage_type]
	far_damage_icon.texture = far_damage_type_icons[far_damage_type]
	pass


func update_health():
	var difficulty: int = difficulty_slider.value
	difficulty_label.modulate = difficulty_color[difficulty]
	difficulty_label.text = "难度： "
	var difficulty_text: String
	match difficulty:
		0: difficulty_text = "简单"
		1: difficulty_text = "普通"
		2: difficulty_text = "困难"
	difficulty_label.text += difficulty_text
	
	var health: int = linked_data.health
	health *= difficulty_rate_list[difficulty]
	health_label.text = str(health)
	
	if eternal_health: health_label.text = "??"
	pass
