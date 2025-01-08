class_name GameServer
extends GameLoop


@onready var player_list: PlayerList = %PlayerList


func _ready() -> void:
	var server_name: String = MultiplayerManager.users[1]
	
	player_list.add_to_player_list(1, server_name)
