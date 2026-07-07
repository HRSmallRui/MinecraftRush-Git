extends ShooterBullet

@export var poison_buff_scene: PackedScene


func enemy_take_damage(enemy: Enemy):
	super(enemy)
	if enemy.enemy_state != Enemy.EnemyState.DIE:
		var poison_buff: DotBuff = poison_buff_scene.instantiate()
		poison_buff.buff_level = special_skill_level
		enemy.buffs.add_child(poison_buff)
	pass
