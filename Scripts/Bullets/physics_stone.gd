extends ShooterBullet

@export var explosion_stone_effect_scene: PackedScene
@export var explosion_damage_list: Array[DamageBlock]

@onready var explosion_hit_area: Area2D = $ExplosionHitArea


func after_attack_process(unit: Node2D):
	super(unit)
	if bullet_special_tag_levels.has("stone_explosion"):
		EffectManager.instance.play_sprite_effect(explosion_stone_effect_scene,position)
		AudioManager.instance.stone_explosion_audio.play()
		var damage_block: DamageBlock = explosion_damage_list[bullet_special_tag_levels["stone_explosion"]-1]
		var total_damage: int
		for box in explosion_hit_area.get_overlapping_areas():
			var new_enemy: Enemy = box.owner
			var origin_health: int = new_enemy.current_data.health
			new_enemy.take_damage(damage_block.get_damage(),DataProcess.DamageType.PhysicsDamage,0,false,source,explosion,true)
			total_damage += origin_health - new_enemy.current_data.health
		Achievement.achieve_int_add("ExplosionStone",total_damage,1200)
	pass
