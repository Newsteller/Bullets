extends Node
class_name Game

const PLAYER = preload("res://characters/player/player.tscn")
@onready var ui: CanvasLayer = %UI

var peer = ENetMultiplayerPeer.new()

var players: Array[Player] = []

func _ready():
	$MultiplayerSpawner.spawn_function = add_player

func _on_host_pressed() -> void:
	peer.create_server(25625)
	multiplayer.multiplayer_peer = peer
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer: " + str(pid) + " has joined!")
			$MultiplayerSpawner.spawn(pid)
	)
	
	$MultiplayerSpawner.spawn(multiplayer.get_unique_id())
	%UI.hide()


func _on_join_pressed() -> void:
	peer.create_client("localhost", 25625)
	multiplayer.multiplayer_peer = peer
	%UI.hide()


func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	return player

func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position
