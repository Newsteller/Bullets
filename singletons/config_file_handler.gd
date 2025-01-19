extends Node


const SETTINGS_FILE_PATH = "user://settings.ini"

var config = ConfigFile.new()

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		# KEY BINDINGS
		config.set_value("keybindings", "move_left", "A")
		config.set_value("keybindings", "move_right", "D")
		config.set_value("keybindings", "jump", "space")
		config.set_value("keybindings", "shoot", "mouse_1")
		
		# VIDEO
		config.set_value("video", "fullscreen", true)
		config.set_value("video", "screen_width", 1920)
		config.set_value("video", "screen_height", 1080)

		# AUDIO
		config.set_value("audio", "master_volume", 1.0)
		config.set_value("audio", "sfx_volume", 1.0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)


func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_video_settings():
	var video_settings = {}
	
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings


func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)


func load_audio_settings():
	var audio_settings = {}
	
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
			
