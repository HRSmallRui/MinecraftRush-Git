extends TextureRect

@onready var button_group: VBoxContainer = $ButtonGroup
@export var mc_font: Font


func _ready() -> void:
	var path_count: int = 0
	for child in get_children():
		if child is Line2D:
			var check_box: CheckBox = CheckBox.new()
			check_box.button_pressed = true
			path_count += 1
			check_box.text = "  " + str(path_count)
			var target_color: Color = child.default_color
			check_box.add_theme_color_override("font_color",target_color)
			check_box.add_theme_color_override("fonrt_hover_color",target_color)
			check_box.add_theme_color_override("font_disabled_color",target_color)
			check_box.add_theme_color_override("font_hover_pressed_color",target_color)
			check_box.add_theme_color_override("font_focus_color",target_color)
			check_box.add_theme_color_override("font_hover_color",target_color)
			check_box.add_theme_color_override("font_pressed_color",target_color)
			check_box.add_theme_font_size_override("font_size",32)
			check_box.add_theme_font_override("font",mc_font)
			check_box.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND	
			check_box.toggled.connect(func(toggle_on: bool):
				child.visible = toggle_on)
			check_box.button_down.connect(func():WikiManager.instance.scroll_locked = true)
			check_box.button_up.connect(func():WikiManager.instance.scroll_locked = false)
			check_box.focus_mode = Control.FOCUS_NONE
			button_group.add_child(check_box)
	pass
