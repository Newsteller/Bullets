extends Node


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed() == true:
			%Cursor.mouse_pressed()
			%Background.shoot_background()
		else:
			%Cursor.mouse_released()


func _on_title_play_button_pressed() -> void:
	pass


func _on_title_quit_button_pressed() -> void:
	get_tree().quit()


func _on_title_settings_button_pressed() -> void:
	pass # Replace with function body.
