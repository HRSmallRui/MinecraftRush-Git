extends DotBuff


func _on_on_dot_buff_damaged(raw_damage: int, damage: int) -> void:
	Achievement.achieve_int_add("NuclearPassive",damage,8000)
	pass # Replace with function body.
