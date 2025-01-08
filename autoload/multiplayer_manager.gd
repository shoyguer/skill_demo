extends Node
## This class is responsible for everything related to the Hosting and Joining
## for the multiplayer.
##
## It will deal with Hosting and Joining a server, as well as dealing with player
## list ([member users]), and the connecting and disconnecting of peers to the
## game.


#region Variable declaration
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
var player_type: PlayerType = PlayerType.HOST

var users: Dictionary = {}
#endregion


## Runs on server side. [br]
## Runs when a player presses the "Host" button in the main menu. [br]
## This will make sure the player is connected, and create an identity for the peer.
func host_game() -> void:
	var server_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	server_peer.create_server(SERVER_PORT, MAX_PLAYERS)
	
	multiplayer.multiplayer_peer = server_peer
	
	multiplayer.peer_disconnected.connect(_peer_disconnected)
	# Everytime a player is connected to the server, this function will
	# call the _send_user_data_to_server, with the [param new_peer_id] as parameter.
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


## Runs on client side. [br]
## Runs when a player presses the "Join" button in the main menu. [br]
## This will make sure the player is connected, and create an identity for the peer.
func join_game() -> void:
	var client_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	client_peer.create_client(SERVER_IP, SERVER_PORT)
	multiplayer.multiplayer_peer = client_peer


## Runs on client side. [br]
## Sends the player data to the server.
@rpc("authority")
func _send_user_data_to_server() -> void:
	var id: int = multiplayer.get_unique_id()
	rpc_id(1, "_register_username", id, username)
 

## Runs on server side. [br]
## When a player just disconnected, this will remove everything about them
## then broadcast it to other players, so the event can display on their chat.
func _peer_disconnected(id: int) -> void:
	if multiplayer.is_server():
		if users.has(id):
			var peer_username = users[id]
			Events.player_disconnected.emit(id, peer_username)
			users.erase(id)
			
			rpc("_event_player_disconnected", peer_username)
			
			rpc("_update_users_list", users)


## Runs on server side. [br]
## Registers the username for a player that just connected, then sends the new
## data to all peers.
@rpc("any_peer", "call_local")
func _register_username(peer_id: int, peer_username: String) -> void:
	if multiplayer.is_server():
		# Updates the server's users dictionary, addin the new user to it
		users[peer_id] = peer_username
		
		# Used for the server only
		Events.player_connected.emit(peer_id, peer_username)
		rpc("_event_player_connected", peer_username)
		
		# Broadcasts the updated users list to all clients
		rpc("_update_users_list", users)


## Runs on client side. [br]
## Will emit a signal, after a player connected. 
## The signal will be used inside the [HUD].
@rpc("authority", "call_local")
func _event_player_connected(peer_username: String) -> void:
	event_happened.emit(peer_username, Event.JOINED)


## Runs on client side. [br]
## Will emit a signal, after a player disconnected. 
## The signal will be used inside the [HUD].
@rpc("authority", "call_local")
func _event_player_disconnected(peer_username: String) -> void:
	event_happened.emit(peer_username, Event.EXITED)


## Runs on client side. [br]
## Updates the [member users] dictionary on all clients.
@rpc("authority", "call_remote")
func _update_users_list(updated_users: Dictionary) -> void:
	if not multiplayer.is_server():
		users = updated_users
