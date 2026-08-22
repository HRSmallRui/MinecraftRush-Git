extends Button

@export var enemy_summon_editor: EnemySummonEditor
@export var enemy_texture: Texture2D
@export var enemy_id: int
@export var enemy_name: String

@onready var enemy_texture_rect: TextureRect = $EnemyTextureRect
@onready var enemy_name_label: Label = $EnemyNameLabel


func _ready() -> void:
	enemy_texture_rect.texture = enemy_texture
	enemy_name_label.text = enemy_name
	pass
