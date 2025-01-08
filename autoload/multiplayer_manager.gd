extends Node
## This class is responsible for everything related to the Hosting and Joining
## for the multiplayer.


## Emitted when a player have logged in or logged off.
signal event_happened(user: String, type: Event)

enum Event {
	JOINED,
	EXITED
}

enum PlayerType {
	HOST,
	PLAYER_0,
	PLAYER_1
}

const SERVER_PORT: int = 8080
const SERVER_IP: String = "127.0.0.1"
const MAX_PLAYERS: int = 2

var username: String = ""

var users: Dictionary = {}


func host_game() -> void:
	var server_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT, MAX_PLAYERS)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	multiplayer.peer_connected.connect(
		func(new_peer_id: int):
			await get_tree().create_timer(1).timeout
			rpc_id(new_peer_id, "_send_user_data_to_server")
	)
	
	# Adds the host to users dictionary.
	var server_id: int = multiplayer.get_unique_id()
	users[server_id] = username
	
	await get_tree().create_timer(1).timeout
	rpc("_event_player_connected", username)


func join_game() -> void:
	var client_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer


@rpc("authority")
func _send_user_data_to_server() -> void:
	var id: int = multiplayer.get_unique_id()
	rpc_id(1, "_register_username", id, username)
 

func _peer_disconnected(id: int) -> void:
	if multiplayer.is_server():
		if users.has(id):
			var peer_username = users[id]
			Events.player_disconnected.emit(id, peer_username)
			users.erase(id)
			
			rpc("_event_player_disconnected", peer_username)
			
			rpc("_update_users_list", users)


@rpc("any_peer", "call_local")
func _register_username(peer_id: int, peer_username: String) -> void:
	if multiplayer.is_server():
		# Updates the server's users dictionary, addin the new user to it
		users[peer_id] = peer_username
		
		Events.player_connected.emit(peer_id, peer_username)
		rpc("_event_player_connected", peer_username)
		
		# Broadcast the updated users list to all clients
		rpc("_update_users_list", users)


@rpc("authority", "call_local")
func _event_player_connected(peer_username: String) -> void:
	event_happened.emit(peer_username, Event.JOINED)


@rpc("authority", "call_local")
func _event_player_disconnected(peer_username: String) -> void:
	event_happened.emit(peer_username, Event.EXITED)


# Updates the users dictionary on all clients
@rpc("authority", "call_remote")
func _update_users_list(updated_users: Dictionary) -> void:
	if not multiplayer.is_server():
		users = updated_users
