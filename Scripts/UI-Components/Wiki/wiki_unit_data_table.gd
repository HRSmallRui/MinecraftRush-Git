@tool
extends VBoxContainer

@export var hero_data: HeroPropertyBlock
@export var level_min: int = 1:
	set(v):
		level_min = v
		call_deferred("change_level_slider_min")

@export var level_max: int = 10:
	set(v):
		level_max = v
		call_deferred("change_level_slider_max")

@export var health_recover_list: Array[int]
@export var rebirth_time: float:
	set(v):
		rebirth_time = v
		call_deferred("update_rebirth")
@export var intercepting_range: int:
	set(v):
		intercepting_range = v
		call_deferred("update_intercepting_range")

@export_group("Attacks")
@export var damage_near_type: DataProcess.DamageType:
	set(v):
		damage_near_type = v
		call_deferred("update_damage_icon")
@export var damage_far_show: bool = true:
	set(v):
		damage_far_show = v
		call_deferred("set_far_attack_part_visible")
@export var damage_far_type: DataProcess.DamageType:
	set(v):
		damage_far_type = v
		call_deferred("update_damage_icon")
@export var damage_far_part: Array[PanelContainer]

@export_group("AttackTypeConfig")
@export var near_damage_type_icons: Array[Texture2D]
@export var far_damage_type_icons: Array[Texture2D]

@onready var level_slider: HSlider = $CenterContainer/HBoxContainer/LevelSlider
@onready var level_label: Label = $CenterContainer/HBoxContainer/LevelLabel
@onready var health_label: Label = $WikiTable/WikiTableElement2/HealthLabel
@onready var health_recover_label: Label = $WikiTable/WikiTableElement4/HealthRecoverLabel
@onready var damage_near_icon: TextureRect = $WikiTable/WikiTableElement5/DamageNearIcon
@onready var damage_near_label: Label = $WikiTable/WikiTableElement6/DamageNearLabel
@onready var damage_near_speed_label: Label = $WikiTable/WikiTableElement8/DamageNearSpeedLabel
@onready var damage_far_icon: TextureRect = $WikiTable/WikiTableElement19/DamageFarIcon
@onready var far_attack_range_label: Label = $WikiTable/WikiTableElement22/FarAttackRangeLabel
@onready var far_attack_speed_label: Label = $WikiTable/WikiTableElement24/FarAttackSpeedLabel
@onready var armor_label: Label = $WikiTable/WikiTableElement10/ArmorLabel
@onready var magic_defence_label: Label = $WikiTable/WikiTableElement12/MagicDefenceLabel
@onready var move_speed_label: Label = $WikiTable/WikiTableElement14/MoveSpeedLabel
@onready var rebirth_label: Label = $WikiTable/WikiTableElement16/RebirthLabel
@onready var intercepting_label: Label = $WikiTable/WikiTableElement18/InterceptingLabel
@onready var xp_rate_label: Label = $WikiTable/WikiTableElement26/XPRateLabel
@onready var far_damage_label: Label = $WikiTable/WikiTableElement20/FarDamageLabel


func _ready() -> void:
	update_property(level_slider.value)
	pass


func _on_level_slider_value_changed(value: float) -> void:
	update_property(value)
	pass # Replace with function body.


func change_level_slider_min():
	level_slider.min_value = level_min
	pass


func change_level_slider_max():
	level_slider.max_value = level_max
	pass


func update_property(level: int):
	level_label.text = "LV." + str(level)
	health_label.text = str(hero_data.max_healths[level-1])
	health_recover_label.text = str(health_recover_list[level-1]) + " /秒"
	var damage_near_block: DamageBlock = hero_data.damage_nears[level-1]
	damage_near_label.text = str(damage_near_block.damage_low) + " - " + str(damage_near_block.damage_high)
	damage_near_speed_label.text = str(hero_data.damage_near_speed) + " 秒"
	var damage_far_block: DamageBlock = hero_data.damage_fars[level-1]
	far_damage_label.text = str(damage_far_block.damage_low) + " - " + str(damage_far_block.damage_high)
	far_attack_range_label.text = str(hero_data.damage_far_range)
	far_attack_speed_label.text = str(hero_data.damage_far_speed) + " 秒"
	armor_label.text = str(int(hero_data.armors[level-1]*100))
	magic_defence_label.text = str(int(hero_data.magic_defences[level-1]*100))
	move_speed_label.text = str(hero_data.move_speed)
	xp_rate_label.text = str(hero_data.xp_speed_rate)
	pass


func update_damage_icon():
	damage_near_icon.texture = near_damage_type_icons[damage_near_type]
	#damage_near_icon.set("tip_text",near_damage_type_intros[damage_near_type])
	damage_far_icon.texture = far_damage_type_icons[damage_far_type]
	#damage_far_icon.set("tip_text",far_damage_type_intros[damage_far_type])
	pass


func set_far_attack_part_visible():
	for container in damage_far_part:
		container.visible = damage_far_show
	pass


func update_rebirth():
	rebirth_label.text = str(rebirth_time) + " 秒"
	pass


func update_intercepting_range():
	intercepting_label.text = str(intercepting_range)
	pass


func _on_level_slider_drag_started() -> void:
	WikiManager.instance.scroll_locked = true
	pass # Replace with function body.


func _on_level_slider_drag_ended(value_changed: bool) -> void:
	WikiManager.instance.scroll_locked = false
	pass # Replace with function body.
