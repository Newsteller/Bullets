extends Node

signal noray_connected

const NORAY_ADDRESS = "tomfol.io"
const NORAY_PORT = 8890

var is_host = false
var external_oid = ""

func _ready() -> void:
	Noray.on_connect_to_host.connect(on_noray_connected)
	Noray.on_connect_nat.connect(handle_nat_connection)
	Noray.on_connect_relay.connect(handle_relay_connection)
	
	Noray.connect_to_host(NORAY_ADDRESS, NORAY_PORT)


func on_noray_connected():
	print("connected")
	Noray.register_host()
	await Noray.on_pid
	await Noray.register_remote()
	noray_connected.emit()


func host():
	print("hosting")

	var peer = ENetMultiplayerPeer.new()
	peer.create_server(Noray.local_port)
	multiplayer.multiplayer_peer = peer
	is_host = true


func join(oid):
	Noray.connect_nat(oid)
	external_oid = oid


func handle_nat_connection(address, port):
	var error = await connect_to_server(address, port)
	
	if error != OK && !is_host:
		print("NAT failed, using relay")
		Noray.connect_relay(external_oid)
		error = OK
	
	return error


func handle_relay_connection(address, port):
	return await connect_to_server(address, port)


func connect_to_server(address, port):
	var error = OK
	
	if !is_host:
		var udp = PacketPeerUDP.new()
		udp.bind(Noray.local_port)
		udp.set_dest_address(address, port)
		
		error = await PacketHandshake.over_packet_peer(udp)
		udp.close()
		
		if error != OK:
			if error != ERR_BUSY:
				print('handshake failed')
				return error
		else:
			print('handshake success')
			
		var peer = ENetMultiplayerPeer.new()
		error = peer.create_client(address, port, 0, 0, 0, Noray.local_port)
		
		if error != OK:
			return error
			
		multiplayer.multiplayer_peer = peer
	
		return OK
	else:
		error = await PacketHandshake.over_enet(multiplayer.multiplayer_peer.host, address, port)
		
	return error
