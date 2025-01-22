extends Control

var user_id
var user_name

func _ready() -> void:
	Steam.steamInit()
	var isSteamRunning = Steam.isSteamRunning()
	
	if !isSteamRunning:
		print("Steam is not running! Please run Steam for this interation.")
		return
	
	user_id = Steam.getSteamID()
	user_name = Steam.getFriendPersonaName(user_id)
	
	Steam.avatar_loaded.connect(_on_loaded_avatar)
	#Steam.getPlayerAvatar()


func _process(delta: float) -> void:
	Steam.run_callbacks()


func _on_loaded_avatar(user_id: int, avatar_size: int, avatar_buffer: PackedByteArray) -> void:
	var avatar_image := Image.create_from_data(avatar_size, avatar_size, false, Image.FORMAT_RGBA8, avatar_buffer)
	var avatar_texture = ImageTexture.create_from_image(avatar_image)
	#$sprite.set_texture(avatar_texture)
