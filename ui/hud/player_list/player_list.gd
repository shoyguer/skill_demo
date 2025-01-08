class_name PlayerList
extends PanelContainer


@export var player_label_scene: PackedScene

@onready var player_list_container: VBoxContainer = %PlayerListContainer


func _ready() -> void:
	pass


@rpc("call_remote")
func add_to_player_list(username: String) -> void:
	var player_label: Label = player_label_scene.instantiate()
	player_list_container.add_child(player_label)
	player_label.text = username
