extends Control


signal options_closed


const WINDOW_RESOLUTIONS = {
	'640 / 480': {'width': 640, 'height': 480},
	'800 / 600': {'width': 800, 'height': 600},
	'1024 / 768': {'width': 1024, 'height': 768},
	'1920 / 1080': {'width': 1920, 'height': 1080},
	'2560 / 1440': {'width': 2560, 'height': 1440},
}


func _ready() -> void:
	var video_settings = ConfigFileHandler.load_video_settings()
	%FullscreenCheckBox.button_pressed = video_settings.fullscreen
	
	var active_resolution = str(DisplayServer.window_get_size().x) + ' / ' + str(DisplayServer.window_get_size().y)
	
	for index in WINDOW_RESOLUTIONS.size():
		var resolution = WINDOW_RESOLUTIONS.keys()[index]
		%ResolutionButton.add_item(resolution)
		if active_resolution == resolution:
			%ResolutionButton.select(index)


	var audio_settings = ConfigFileHandler.load_audio_settings()
	%MasterVolumeSlider.value = audio_settings.master_volume * 100
	%SFXVolumeSlider.value = audio_settings.sfx_volume * 100

func _on_resolution_button_item_selected(index: int) -> void:
	var selected_resolution = WINDOW_RESOLUTIONS[%ResolutionButton.get_item_text(index)]
	DisplayServer.window_set_size(Vector2i(selected_resolution.width, selected_resolution.height))
	ConfigFileHandler.save_video_settings("screen_width", selected_resolution.width)
	ConfigFileHandler.save_video_settings("screen_height", selected_resolution.height)


func _on_fullscreen_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
	%ResolutionButton.disabled = toggled_on
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
	SceneSwitcher.change_scene(self, "res://menus/title/title.tscn")
