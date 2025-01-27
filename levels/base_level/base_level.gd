class_name BaseLevel
extends Node2D


var players: Array[Player] = []


const PLAYER = preload("res://characters/player/player.tscn")


func _ready():
	Steam.network_messages_session_request.connect(_on_network_messages_session_request)
	Steam.network_messages_session_failed.connect(_on_network_messages_session_failed)
	
	# Check for command line arguments
	#check_command_line()
	#$MultiplayerSpawner.spawn_function = add_player


func _process(_delta) -> void:
	# If the player is connected, read packets
	if SteamMain.lobby_id > 0:
		read_messages()


func read_messages() -> void:
	var messages: Array = Steam.receiveMessagesOnChannel(0, 1000)
	
	#if packet_size > 0:
	for message in messages:
		if message.is_empty() or message == null:
			print("WARNING: read an empty message with non-zero size!")
		else:
			message.payload = bytes_to_var(message.payload).decompress_dynamic(-1, FileAccess.COMPRESSION_GZIP)
			# Get the remote user's ID
			#var message_sender: int = this_packet['remote_steam_id']
			
			# Print the packet to output
			print("Message: %s" % message.payload)
			# Append logic here to deal with message data. 


func send_message(this_target: int, packet_data: Dictionary) -> void:
	# Set the send_type and channel
	var send_type: int = Steam.NETWORKING_SEND_RELIABLE_NO_NAGLE
	var channel: int = 0
	
	# Create a data array to send the data through
	var this_data: PackedByteArray
	this_data.append_array(var_to_bytes(packet_data).compress(FileAccess.COMPRESSION_GZIP))
	
	# If sending a packet to everyone
	if this_target == 0:
		# If there is more than one user, send packets
		if SteamMain.lobby_members.size() > 1:
			# Loop through all members that aren't you
			for this_member in SteamMain.lobby_members:
				if this_member['steam_id'] != SteamMain.steam_id:
					Steam.sendMessageToUser(this_member['steam_id'], this_data, send_type, channel)
					
	# Else send it to someone specific
	else:
		Steam.sendMessageToUser(this_target, this_data, send_type, channel)


func add_player(pid):
	var player = PLAYER.instantiate()
	player.name = str(pid)
	player.global_position = %SpawnPoints.get_child(players.size()).global_position
	players.append(player)
	return player


func get_random_spawnpoint():
	return %SpawnPoints.get_children().pick_random().global_position


func _on_network_messages_session_request(remote_id: int) -> void:
	# Get the requester's name
	var this_requester: String = Steam.getFriendPersonaName(remote_id)
	print("%s is requesting a P2P session" % this_requester)
	
	# Accept the P2P session; can apply logic to deny this request if needed
	Steam.acceptSessionWithUser(remote_id)


func _on_network_messages_session_failed(steam_id: int, session_error: int, state: int, debug_msg: String) -> void:
	print(debug_msg)
