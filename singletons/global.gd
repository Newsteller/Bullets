extends Node


const INIT_RESPONSE = {
	0: 'Successfully initialized',
	1: 'Some other failure',
	2: 'We cannot connect to Steam, steam probably isn\'t running',
	3: 'Steam client appears to be out of date'
}

var is_online: bool = Steam.loggedOn()
var is_owned: bool = Steam.isSubscribed()
var steam_id: int = Steam.getSteamID()
var steam_username: String = Steam.getPersonaName()


var data
var lobby_id = 0
var lobby_name = 'Default name'
var lobby_members = []
var lobby_invite_arg = false


func _ready() -> void:
	initialize_steam()


func _process(delta: float) -> void:
	Steam.run_callbacks()


func initialize_steam() -> void:
	var initialize_response: Dictionary = Steam.steamInitEx()
	print("Did Steam initialize?: %s " % INIT_RESPONSE[initialize_response.status])
	
	if initialize_response['status'] > 0:
		print('Exiting the game due to Steam not running')
		get_tree().quit()
	
	is_online = Steam.loggedOn()
	steam_id = Steam.getSteamID()
	steam_username = Steam.getPersonaName()
	is_owned = Steam.isSubscribed()
	
	if !is_owned:
		print('User don\'t own this game')
		get_tree().quit()
