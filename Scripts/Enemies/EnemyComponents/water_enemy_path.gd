extends EnemyPath


func on_enemy_summoning(enemy: Enemy):
	EffectManager.instance.play_block_effect(enemy.position,Vector2.ONE,Color(0,0.8,1,0.6))
	AudioManager.instance.play_water_audio()
	pass
