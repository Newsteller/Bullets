extends Node


func _ready() -> void:
	SteamNetworkController.lobby_created_signal.connect(on_lobby_created)
	SteamNetworkController.lobby_joined_signal.connect(on_lobby_joined)


func _on_host_pressed() -> void:
	SteamNetworkController.create_lobby()


func _on_join_pressed() -> void:
	var lobby_id: int = int(%LobbyID.text)
	if lobby_id:
		SteamNetworkController.join_lobby(lobby_id)
		%LobbyID.text = str(lobby_id)
	else:
		%LobbyID.text = "INVALID LOBBY ID!"


func on_lobby_created(lobby_id: int) -> void:
	%LobbyID.text = str(lobby_id)
	print(lobby_id)
	SceneSwitcher.switch_scene("res://aaatest/game_steam.tscn")


func on_lobby_joined(lobby_id: int) -> void:
	SceneSwitcher.switch_scene("res://aaatest/game_steam.tscn")
