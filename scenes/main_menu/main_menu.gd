extends Control


func _ready() -> void:
	%StartButton.grab_focus()	

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_game/main_game.tscn")


func _on_options_button_pressed() -> void:
	var options_instance = preload("res://scenes/options/options.tscn").instantiate()
	get_tree().current_scene.add_child(options_instance)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
