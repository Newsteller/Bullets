extends Node


func _ready() -> void:
	SteamNetworkController.lobby_created_signal.connect(on_lobby_created)


func _on_host_pressed() -> void:
	SteamNetworkController.create_lobby()


func on_lobby_created(lobby_id: int) -> void:
	%LobbyID.text = str(lobby_id)


func _on_join_pressed() -> void:
	var lobby_id: int = int(%LobbyID.text)
	SteamNetworkController.join_lobby(lobby_id)
