extends Control


const SETTINGS: Resource = preload("res://menus/settings/settings.tscn")


func _on_play_button_pressed() -> void:
	pass


func _on_settings_button_pressed() -> void:
	SceneSwitcher.change_scene(self, "res://menus/settings/settings.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
