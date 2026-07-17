extends Ally
class_name Reinforcement

#@export var reinforce_partners: Array[Reinforcement]
@export var reinforce_level: int
@export var reinforce_animation_list: Array[SpriteFrames]
@export var reinforce_headtex_list: Array[Texture]
@export var reinforce_name_list: Array[PackedStringArray]


func _ready() -> void:
	ally_sprite.sprite_frames = reinforce_animation_list[ally_id-1]
	ally_texture = reinforce_headtex_list[ally_id-1]
	modulate.a = 0
	super()
	ally_sprite.play("start")
	translate_to_new_state(AllyState.SPECIAL)
	create_tween().tween_property(self,"modulate:a",1,0.4)
	rebirth_timer.start()
	rebirth_time = 0
	
	var allocate_name_list: Array = reinforce_name_list[ally_id-1]
	ally_name = allocate_name_list[randi_range(0,allocate_name_list.size()-1)]
	pass


func die(explosion):
	super(explosion)
	var target_pos: Vector2 = position
	target_pos += Vector2(50,0) if ally_sprite.flip_h else Vector2(-50,0)
	move_animation(target_pos)
	create_tween().tween_property(self,"modulate:a",0,0.4)
	await move_tween.finished
	queue_free()
	pass


func rebirth():
	die(false)
	pass
