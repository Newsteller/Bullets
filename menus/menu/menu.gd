extends Node




func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("shoot"):
		%Cursor.mouse_pressed()
		%Background.shoot_background()
		
	if Input.is_action_just_released("shoot"):
		%Cursor.mouse_released()


func _on_title_play_button_pressed() -> void:
	pass


func _on_title_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_title_quit_button_pressed() -> void:
	get_tree().quit()
