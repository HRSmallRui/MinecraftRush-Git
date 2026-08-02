extends BuyingSoldier


func anim_offset():
	match ally_sprite.animation:
		"attack","idle":
			ally_sprite.position = Vector2(-30,-125) if ally_sprite.flip_h else Vector2(30,-125)
		"move":
			ally_sprite.position = Vector2(-20,-95) if ally_sprite.flip_h else Vector2(20,-95)
		"start":
			ally_sprite.position = Vector2(-20,-195) if ally_sprite.flip_h else Vector2(15,-195)
		"die":
			ally_sprite.position = Vector2(60,-90) if ally_sprite.flip_h else Vector2(-65,-90)
	pass


func frame_changed():
	if ally_sprite.animation == "attack" and ally_sprite.frame == 11:
		cause_damage()
	pass
