extends Node


signal event_happened(user: String, type: Event )

enum Event {
	JOINED,
	EXITED
}

const SERVER_PORT: int = 8080
const SERVER_IP: String = "127.0.0.1"
const MAX_PLAYERS: int = 2

var user_name: String = ""


func host_game() -> void:
	var server_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT, MAX_PLAYERS)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_delete_player)
	
	if multiplayer.is_server():
		print("I am the host. My peer ID is:", multiplayer.get_unique_id())  # Will print "1"


func join_game() -> void:
	var client_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	
	multiplayer.multiplayer_peer = client_peer


func _add_player(_id: int) -> void:
	event_happened.emit(user_name, Event.JOINED)
 

func _delete_player(_id: int) -> void:
	event_happened.emit(user_name, Event.EXITED)
