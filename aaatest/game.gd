class_name GameSteam
extends Node


const PLAYER = preload("res://characters/player/player.tscn")


var peer = ENetMultiplayerPeer.new()
var players: Array[Player] = []

func _ready():
	$MultiplayerSpawner.spawn_function = add_player
	$MultiplayerSpawner.spawn()


func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = $Level.get_child(players.size()).global_position
	players.append(player)
	return player


func get_random_spawnpoint():
	return $Level.get_children().pick_random().global_position
