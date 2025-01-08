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

var users: Dictionary = {}


func _ready() -> void:
	multiplayer.peer_connected.connect(_send_user_name)


func host_game() -> void:
	var server_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT, MAX_PLAYERS)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	
	# Adds the host to users dictionary.
	var server_id: int = multiplayer.get_unique_id()
	users[server_id] = user_name


func join_game() -> void:
	var client_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer


func _peer_connected(_id: int) -> void:
	pass
	#print("User Joined")
 

func _peer_disconnected(id: int) -> void:
	if multiplayer.is_server():
		if users.has(id):
			var username = users[id]
			users.erase(id)
			event_happened.emit(username, Event.EXITED)
			
			rpc("_update_users_list", users)


func _send_user_name(id: int) -> void:
	var new_player_id = multiplayer.get_remote_sender_id()
	rpc_id(1, "_register_user_name", new_player_id, user_name)


@rpc("any_peer", "call_remote", "reliable")
func _register_user_name(peer_id: int, username: String) -> void:
	if multiplayer.is_server():
		#print("Received user_name from peer %d: %s" % [peer_id, username])
		users[peer_id] = username  # Update the server's users dictionary
		event_happened.emit(username, Event.JOINED)
		
		# Broadcast the updated users list to all clients
		rpc("_update_users_list", users)


# Updates the users dictionary on all clients
@rpc("authority", "call_remote")
func _update_users_list(updated_users: Dictionary) -> void:
	users = updated_users
	print(users)
