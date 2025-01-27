extends Control


func _ready() -> void:
	%SteamName.text = SteamMain.steam_username
	%LobbySetName.text = SteamMain.steam_username + "'s lobby"
	update_play_button()
	
	Steam.lobby_created.connect(on_lobby_created)
	Steam.lobby_joined.connect(on_lobby_joined)
	Steam.lobby_data_update.connect(on_lobby_data_update)
	Steam.lobby_chat_update.connect(on_lobby_chat_update)
	Steam.lobby_match_list.connect(on_lobby_match_list)
	Steam.lobby_message.connect(on_lobby_message)
	
	check_command_line()


func update_play_button() -> void:
	%Start.disabled = SteamMain.lobby_id == 0


func create_lobby() -> void:
	if SteamMain.lobby_id == 0:
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, SteamMain.lobby_max_members)


func join_lobby(lobby_id):
	%LobbyPopupPanel.hide()
	var name = Steam.getLobbyData(lobby_id, "name")
	display_message("Joining lobby: " + str(name) + "...")
	
	SteamMain.lobby_members.clear()
	
	Steam.joinLobby(lobby_id)


func send_chat_message() -> void:
	var message = %MessageText.text
	var sent = Steam.sendLobbyChatMsg(SteamMain.lobby_id, message)
	
	if !sent:
		display_message("Message has not been sent.")
	
	%MessageText.text = ""


func display_message(message: String) -> void:
	%ChatMessages.add_text("\n" + message)


func get_lobby_members() -> void:
	SteamMain.lobby_members.clear()
	var member_count = Steam.getNumLobbyMembers(SteamMain.lobby_id)
	%PlayerCount.set_text("Players (" + str(member_count) + ")")
	
	for member in member_count:
		var member_steam_id = Steam.getLobbyMemberByIndex(SteamMain.lobby_id, member)
		var member_steam_name = Steam.getFriendPersonaName(member_steam_id)
		add_player_to_list(member_steam_id, member_steam_name)


func add_player_to_list(steam_id: int, steam_name: String) -> void:
	SteamMain.lobby_members.append({"steam_id": steam_id, "steam_name": steam_name})
	%PlayerList.clear()
	
	for member in SteamMain.lobby_members:
		%PlayerList.add_text(str(member.steam_name) + "\n")


func check_command_line() -> void:
	var these_arguments: Array = OS.get_cmdline_args()
	if these_arguments.size() > 0:
		if these_arguments[0] == "+connect_lobby":
			if int(these_arguments[1]) > 0:
				# At this point, you'll probably want to change scenes
				# Something like a loading into lobby screen
				print("Command line lobby ID: %s" % these_arguments[1])
				join_lobby(int(these_arguments[1]))


func leave_lobby() -> void:
	if SteamMain.lobby_id != 0:
		display_message("Leaving lobby...")
		Steam.leaveLobby(SteamMain.lobby_id)
		SteamMain.lobby_id = 0
		
		%LobbySetName.text = SteamMain.steam_username + "'s lobby"
		%PlayerCount.text = "Players (0)"
		%PlayerList.clear()
		
		for member in SteamMain.lobby_members:
			Steam.closeP2PSessionWithUser(member["steam_id"])
		
		SteamMain.lobby_members.clear()


func on_lobby_created(connect: int, this_lobby_id: int):
	if connect == 1:
		SteamMain.lobby_id = this_lobby_id
		display_message('Created lobby: ' + %LobbySetName.text)
		
		Steam.setLobbyData(SteamMain.lobby_id, "name", %LobbySetName.text)
		Steam.allowP2PPacketRelay(true)
		var name = Steam.getLobbyData(SteamMain.lobby_id, "name")
		%LobbyGetName.text = str(name)
		update_play_button()


func on_lobby_joined(lobby_id, permissions, locked, response) -> void:
	SteamMain.lobby_id = lobby_id
	var name = Steam.getLobbyData(SteamMain.lobby_id, "name")
	%LobbyGetName.text = name
	get_lobby_members()
	update_play_button()


func on_lobby_join_request(lobby_id, friend_id) -> void:
	var owner_name = Steam.getFriendPersonaName(friend_id)
	display_message("Joining " + str(owner_name) + " lobby...")
	join_lobby(lobby_id)


func on_lobby_data_update(success, lobby_id, member_id, key) -> void:
	print("Success: " + str(success) + ", Lobby ID: " + str(lobby_id) + ", Member ID: " + str(member_id) + ", Key: " + str(key))


func on_lobby_chat_update(lobby_id, changed_id, making_change_id, chat_state) -> void:
	var changer = Steam.getFriendPersonaName(making_change_id)
	
	match chat_state:
		Steam.CHAT_MEMBER_STATE_CHANGE_ENTERED:
			display_message(str(changer) + " has joined the lobby.")
		Steam.CHAT_MEMBER_STATE_CHANGE_LEFT:
			display_message(str(changer) + " has left the lobby.")
		Steam.CHAT_MEMBER_STATE_CHANGE_DISCONNECTED:
			display_message(str(changer) + " has been disconnected.")
		Steam.CHAT_MEMBER_STATE_CHANGE_KICKED:
			display_message(str(changer) + " has been kicked from the lobby.")
		Steam.CHAT_MEMBER_STATE_CHANGE_BANNED:
			display_message(str(changer) + " has been banned from the lobby.")
		_:
			display_message(str(changer) + " did something?")

	get_lobby_members()


func on_lobby_match_list(lobbies) -> void:
	for lobby in lobbies:
		var lobby_name = Steam.getLobbyData(lobby, "name")
		var lobby_members = Steam.getNumLobbyMembers(lobby)
		var lobby_button = Button.new()
		
		print(lobby)
		lobby_button.set_text(str(lobby_name) + " - (" + str(lobby_members) + ")")
		lobby_button.set_size(Vector2(800, 50))
		lobby_button.set_name("lobby_" + str(lobby))
		lobby_button.pressed.connect(join_lobby.bind(lobby))
		
		%LobbyList.add_child(lobby_button)


func on_lobby_message(result, user, message, type) -> void:
	var sender = Steam.getFriendPersonaName(user)
	display_message(str(sender) + ": " + str(message))


func _on_create_pressed() -> void:
	create_lobby()


func _on_join_pressed() -> void:
	%LobbyPopupPanel.popup()
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_WORLDWIDE)
	display_message("Searching for lobbies...")
	Steam.requestLobbyList()


func _on_popup_close_pressed() -> void:
	%LobbyPopupPanel.hide()


func _on_message_send_pressed() -> void:
	send_chat_message()


func _on_leave_pressed() -> void:
	leave_lobby()


func _on_start_pressed() -> void:
	SceneSwitcher.move_to_scene("res://levels/dirt/dirt.tscn")


func _on_back_button_pressed() -> void:
	SceneSwitcher.replace_scene(self, "res://menus/title/title.tscn")
