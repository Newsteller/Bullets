class_name GameSteam
extends Node

@onready var ui: CanvasLayer = %UI
@onready var loading_label: Label = $UI/Multiplayer/VBoxContainer/LoadingLabel

const PLAYER = preload("res://characters/player/player.tscn")

var peer = ENetMultiplayerPeer.new()
var players: Array[Player] = []

func _ready():
	$MultiplayerSpawner.spawn_function = add_player
	SteamNetworkController.lobby_created_signal.connect(on_lobby_created)


func _on_host_pressed() -> void:
	SteamNetworkController.create_lobby()

	$MultiplayerSpawner.spawn()
	%UI.hide()


func _on_join_pressed() -> void:
	var lobby_id: int = int(%LobbyID.text)
	SteamNetworkController.join_lobby(lobby_id)
	%UI.hide()


func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	return player


func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position


func on_lobby_created(lobby_id: int) -> void:
	%LobbyID.text = str(lobby_id)
