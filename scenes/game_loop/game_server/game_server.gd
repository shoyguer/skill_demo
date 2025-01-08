class_name GameServer
extends GameLoop
## The [GameServer] deals only with the Host view of the server.
## 
## The host will have a different view for the server, they are able to zoom
## in and out, and can manage the damage modifier, the spawn of enemy and allied
## units to the game.


@onready var player_list: PlayerList = %PlayerList


func _ready() -> void:
	var server_name: String = MultiplayerManager.users[1]
	
	player_list.add_to_player_list(1, server_name)
