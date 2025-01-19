extends Control

signal play_button_pressed
signal options_button_pressed
signal quit_button_pressed


func _on_play_button_pressed() -> void:
	play_button_pressed.emit()


func _on_options_button_pressed() -> void:
	options_button_pressed.emit()


func _on_quit_button_pressed() -> void:
	quit_button_pressed.emit()
