extends Control


func _ready() -> void:
	_animate_title()


func _animate_title() -> void:
	var animation_tween = get_tree().create_tween()
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.tween_property(%BulletsImage, "scale", Vector2(1.1, 1.1), 0.3).set_trans(Tween.TRANS_QUINT)
	animation_tween.tween_property(%BulletsImage, "scale", Vector2(1, 1), 0.3)

func _on_play_button_pressed() -> void:
	SceneSwitcher.replace_scene(self, "res://menus/steam_lobby/steam_lobby.tscn")


func _on_settings_button_pressed() -> void:
	SceneSwitcher.replace_scene(self, "res://menus/settings/settings.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit()
