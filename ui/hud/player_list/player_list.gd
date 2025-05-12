class_name PlayerList
extends PanelContainer
## This list will display all the current logged player data to the server owner.


## This [PackedScene] will be the scene instantiated to show the player data
## to the server owner.
@export var player_label_scene: PackedScene

@onready var player_list_container: VBoxContainer = %PlayerListContainer


func _ready() -> void:
	Events.player_connected.connect(add_to_player_list)


## When a new player is logged in, their name data will be displayed to the
## server owner.
func add_to_player_list(
	id: int,
	username: String,
	type: MultiplayerManager.PlayerType
) -> void:
	var player_label: Label = player_label_scene.instantiate()
	player_list_container.add_child(player_label)
	var string_type: String = MultiplayerManager.PlayerType.find_key(type)
	string_type = string_type.to_lower()
	string_type = string_type.capitalize()
	player_label.text = string_type + "  |  " + "Name: " + username
	# Sets meta data to the label, so it can be searched later on the 
	# remove_from_player_list function.
	player_label.set_meta("id", id)


## If a player have disconnected, they will be removed from the list.
func remove_from_player_list(id: int, _username: String) -> void:
	# Loops through all the children from the player_list_container, searching
	# for the corrent label to be deleted.
	for label: Label in player_list_container.get_children():
		if label.get_meta("id") == id:
			label.queue_free()
			break
