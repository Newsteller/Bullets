extends Control


signal options_closed


func _ready() -> void:
	var video_settings = ConfigFileHandler.load_video_settings()
	%FullscreenCheckBox.button_pressed = video_settings.fullscreen
	
	var audio_settings = ConfigFileHandler.load_audio_settings()
	%MasterVolumeSlider.value = audio_settings.master_volume * 100
	%SFXVolumeSlider.value = audio_settings.sfx_volume * 100

func _on_resolution_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(640, 480))
			ConfigFileHandler.save_video_settings("screen_width", 640)
			ConfigFileHandler.save_video_settings("screen_height", 480)
		1:
			DisplayServer.window_set_size(Vector2i(800, 600))
			ConfigFileHandler.save_video_settings("screen_width", 800)
			ConfigFileHandler.save_video_settings("screen_height", 600)
		2:
			DisplayServer.window_set_size(Vector2i(1024, 768))
			ConfigFileHandler.save_video_settings("screen_width", 1024)
			ConfigFileHandler.save_video_settings("screen_height", 768)
		3:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
			ConfigFileHandler.save_video_settings("screen_width", 1920)
			ConfigFileHandler.save_video_settings("screen_height", 1080)
		4:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
			ConfigFileHandler.save_video_settings("screen_width", 2560)
			ConfigFileHandler.save_video_settings("screen_height", 1440)


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	ConfigFileHandler.save_video_settings("fullscreen", toggled_on)


func _on_audio_master_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(0, value_changed)
		ConfigFileHandler.save_audio_settings("master_volume", %MasterVolumeSlider.value / 100)


func _on_audio_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(1, value_changed)
		ConfigFileHandler.save_audio_settings("sfx_volume", %SFXVolumeSlider.value / 100)


func _on_back_button_pressed() -> void:
	options_closed.emit(true)
