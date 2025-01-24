extends Control


func _on_play_button_pressed() -> void:
	SceneSwitcher.change_scene(self, "res://menus/lobby/lobby.tscn")


func _on_settings_button_pressed() -> void:
	SceneSwitcher.change_scene(self, "res://menus/settings/settings.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
