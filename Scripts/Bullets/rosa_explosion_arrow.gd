extends ShooterBullet

@export var explosion_damage_list: Array[IntSaver]

@onready var explosion_area: Area2D = $ExplosionArea

var has_exploded: bool


func _ready() -> void:
	free_timer.wait_time = (target_position - self.global_position).length() / bullet_speed + 0.1
	super()
	pass


func enemy_take_damage(enemy: Enemy):
	super(enemy)
	explode()
	pass


func _on_free_timer_timeout():
	super()
	explode()
	pass


func explode():
	if has_exploded: return
	has_exploded = true
	AudioManager.instance.play_explosion_audio()
	EffectManager.instance.play_explosion_effect(position)
	
	var damage: int = explosion_damage_list[special_skill_level-1].saving_int_value
	for hurt_box in explosion_area.get_overlapping_areas():
		var enemy: Enemy = hurt_box.owner
		enemy.take_damage(damage,DataProcess.DamageType.ExplodeDamage,0,true,null,true,true,)
	pass
