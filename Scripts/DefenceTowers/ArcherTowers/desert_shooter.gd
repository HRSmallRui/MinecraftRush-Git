extends Shooter

@export_range(0,1,0.01) var critical_possible: float
@export var critical_damage_rate: float
@export var critical_broken_rate: float


func anim_offset():
	match animation:
		"idle_front","shoot_front":
			offset = Vector2(-10,0) if flip_h else Vector2.ZERO
		"shoot_back":
			offset = Vector2(-6,0) if flip_h else Vector2(-5,0)
	pass

func summon_bullet(summon_pos: Vector2, target_pos: Vector2, bullet_scene: PackedScene = arrow_scene) -> Bullet:
	var bullet: Bullet = super(summon_pos,target_pos,bullet_scene)
	if randf_range(0,1) < critical_possible:
		bullet.damage *= critical_damage_rate
		bullet.broken_rate = critical_broken_rate
		bullet.bullet_special_tags_array.append("CriticalHit")
	return bullet
	pass
