extends Node


@export var _players_spawn_node: Node2D

var steam_network_scene := preload("res://steam/managers/steam_network_scene.tscn")
var active_network
var host_mode_enabled: bool = false

func _build_multiplayer_network():
	if not active_network:
		_set_active_network(steam_network_scene)

func _set_active_network(active_network_scene):
	var network_scene_initialized = active_network_scene.instantiate()
	active_network = network_scene_initialized
	active_network._players_spawn_node = _players_spawn_node
	add_child(active_network)

func become_host(is_dedicated_server = false):
	_build_multiplayer_network()
	host_mode_enabled = true if is_dedicated_server == false else false
	active_network.become_host()
	
func join_as_client(lobby_id = 0):
	_build_multiplayer_network()
	active_network.join_as_client(lobby_id)
	
func list_lobbies():
	_build_multiplayer_network()
	active_network.list_lobbies()
