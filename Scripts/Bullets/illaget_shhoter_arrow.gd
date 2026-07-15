extends ShooterBullet

@export var illager_damage_rate: FloatSaver


func enemy_take_damage(enemy: Enemy):
	if "ilagger" in enemy.get_groups():
		var rate: float = illager_damage_rate.saving_float_value
		damage *= rate
		damage_type = DataProcess.DamageType.TrueDamage
	super(enemy)
	pass
