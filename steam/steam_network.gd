extends Node

const PACKET_READ_LIMIT := 32
const TARGET_TYPE = {
	"EVERYONE": 0
}
const DEFAULT_CHANNEL = 0

var is_host := false
var lobby_id: int = 0
var lobby_members := []
var lobby_members_max := 4
var lobby_type := Steam.LOBBY_TYPE_PUBLIC
var lobby_name := "Default lobby name"


func _ready() -> void:
	Steam.lobby_created.connect(on_lobby_created)
	Steam.lobby_joined.connect(_on_lobby_joined)
	Steam.p2p_session_request.connect(_on_p2p_session_request)


func _process(delta: float) -> void:
	if lobby_id > 0:
		read_all_p2p_packets()


func create_lobby():
	if lobby_id == 0:
		is_host = true
		Steam.createLobby(lobby_type, lobby_members_max)


func on_lobby_created(connect: int, this_lobby_id: int):
	if connect == 1:
		lobby_id = this_lobby_id
		
		Steam.setLobbyJoinable(lobby_id, true)
		
		Steam.setLobbyData(lobby_id, "name", lobby_name)
		
		var set_relay := Steam.allowP2PPacketRelay(true)


func join_lobby(this_lobby_id: int):
	Steam.joinLobby(this_lobby_id)


func get_lobby_members():
	lobby_members.clear()
	
	var num_of_lobby_members: int = Steam.getNumLobbyMembers(lobby_id)
	
	for member in num_of_lobby_members:
		var member_steam_id: int = Steam.getLobbyMemberByIndex(lobby_id, member)
		var member_steam_name: String = Steam.getFriendPersonaName(member_steam_id)
		
		lobby_members.append({
			"steam_id": member_steam_id,
			"steam_name": member_steam_name
		})


func send_p2p_packet(target: int, packet_data: Dictionary, sent_type: int = 0) -> void:
	var channel: int = 0
	
	var data: PackedByteArray
	data.append_array(var_to_bytes(packet_data))
	
	if target == TARGET_TYPE.EVERYONE:
		if lobby_members.size() > 1:
			for member in lobby_members:
				if member["steam_id"] != SteamController.steam_id:
					Steam.sendP2PPacket(member['steam_id'], data, sent_type, channel)
	else:
		Steam.sendP2PPacket(target, data, sent_type, channel)


func read_p2p_packet():
	var packet_size: int = Steam.getAvailableP2PPacketSize(DEFAULT_CHANNEL)

	if packet_size > 0:
		var current_packet: Dictionary = Steam.readP2PPacket(packet_size, DEFAULT_CHANNEL)
		var packet_sender: int = current_packet['remote_steam_id']
		var packet_code: PackedByteArray = current_packet['data']
		var readable_data: Dictionary = bytes_to_var(packet_code)
		
		if readable_data.has("message"):
			match readable_data["message"]:
				"handshake":
					print("PLAYER: ", readable_data["username"], " HAS JOINED")
					get_lobby_members()

func read_all_p2p_packets(read_count: int = 0):
	if read_count >= PACKET_READ_LIMIT:
		return
	
	if Steam.getAvailableP2PPacketSize(DEFAULT_CHANNEL) > 0:
		read_p2p_packet()
		read_all_p2p_packets(read_count + 1)


func make_p2p_handshake():
	send_p2p_packet(0, {"message": "handshake", "steam_id": SteamController.steam_id, "username": SteamController.user_name})


func _on_lobby_joined(this_lobby_id: int, _permissions: int, _locked: bool, response: int):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobby_id = this_lobby_id
		
		get_lobby_members()
		make_p2p_handshake()


func _on_p2p_session_request(remote_id: int):
	var requester: String = Steam.getFriendPersonaName(remote_id)
	
	Steam.acceptP2PSessionWithUser(remote_id)
