class_name GameServer
extends GameLoop
## The [GameServer] deals only with the Host view of the server.
## 
## The host will have a different view for the server, they are able to zoom
## in and out, and can manage the damage modifier, the spawn of enemy and allied
## units to the game.


## By how much the zoom will be modified
@export var zoom_modifier: Vector2 = Vector2(0.05, 0.05)
## The minimum value the zoom can assume. [br]
## The lower the value, the the farther to the image.
@export var zoom_min: Vector2 = Vector2(0.2, 0.2)
## The maximum value the zoom can assume. [br]
## The higher the value, the closer to the image.
@export var zoom_max: Vector2 = Vector2(1.0, 1.0)

@onready var player_list: PlayerList = %PlayerList
@onready var camera: Camera2D = $Camera2D


func _ready() -> void:
	is_server_side = true
	super()
	
	var server_name: String = MultiplayerManager.users[1]
	
	player_list.add_to_player_list(1, server_name, MultiplayerManager.PlayerType.HOST)


func _input(event: InputEvent) -> void:
	# This is responsible for changing the zoom
	if event is InputEventMouseButton:
		if event.button_index == 5:
			camera.zoom -= zoom_modifier
			camera.zoom = clamp(camera.zoom, zoom_min, zoom_max)
		
		if event.button_index == 4:
			camera.zoom += zoom_modifier
			camera.zoom = clamp(camera.zoom, zoom_min, zoom_max)
