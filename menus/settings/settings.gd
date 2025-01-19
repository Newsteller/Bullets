extends Control


signal options_closed


func _on_audio_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)


func _on_resolution_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(640, 480))
		1:
			DisplayServer.window_set_size(Vector2i(800, 600))
		2:
			DisplayServer.window_set_size(Vector2i(1024, 768))
		3:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		4:
			DisplayServer.window_set_size(Vector2i(2560, 1440))


func _on_back_button_pressed() -> void:
	options_closed.emit(true)
