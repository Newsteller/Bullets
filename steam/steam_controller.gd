extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Steam.steamInit()
	var isSteamRunning = Steam.isSteamRunning()
	
	if !isSteamRunning:
		print("Steam is not running! Please run Steam for this interation.")
		return
	
	var userId = Steam.getSteamID()
	var name = Steam.getFriendPersonaName(userId)
	print("Your Steam name is: ", name)
	%Name.text = name
	
	Steam.avatar_loaded.connect(avatar_loaded)
	Steam.getPlayerAvatar()


func avatar_loaded(id, size, buffer):
	var avatarImage = Image.create_from_data(size, size, false, Image.FORMAT_RGBA8, buffer)
	var texture = ImageTexture.create_from_image(avatarImage)
	%Avatar.texture = texture
