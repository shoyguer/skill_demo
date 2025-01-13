class_name GameServer
extends GameLoop
## The [GameServer] deals only with the Host view of the server.
## 
## The host will have a different view for the server, they are able to zoom
## in and out, and can manage the damage modifier, the spawn of enemy and allied
## units to the game.


@export_group("Server Settings")
@export var enemy_number: int = 10
@export var aircraft_spawn_offset: float = 200.0
@export var aircraft_altitude_range: Vector2 = Vector2(6000, 20000)

@export var is_server_view: bool = true

@export_group("Camera Zoom")
## By how much the zoom will be modified
@export var zoom_modifier: Vector2 = Vector2(0.05, 0.05)
## The minimum value the zoom can assume. [br]
## The lower the value, the the farther to the image.
@export var zoom_min: Vector2 = Vector2(0.2, 0.2)
## The maximum value the zoom can assume. [br]
## The higher the value, the closer to the image.
@export var zoom_max: Vector2 = Vector2(1.0, 1.0)

@onready var player_list: PlayerList = %PlayerList

@onready var option_damage: OptionFloatContainer = %OptionDamage
@onready var option_ntds: OptionCheckContainer = %OptionNTDS
@onready var option_spawn: OptionButtonContainer = %OptionSpawn



func _ready() -> void:
	is_server_side = true
	super()
	
	var server_name: String = MultiplayerManager.users[1]
	
	player_list.add_to_player_list(1, server_name, MultiplayerManager.PlayerType.HOST)
	
	option_damage.float_changed.connect(_damage_multiplier_changed)
	option_ntds.button_toggled.connect(_change_object_view)
	option_spawn.button_pressed.connect(_spawn_enemies)


func _input(event: InputEvent) -> void:
	# This is responsible for changing the zoom
	if event is InputEventMouseButton:
		if event.button_index == 5:
			camera.zoom -= zoom_modifier
			camera.zoom = clamp(camera.zoom, zoom_min, zoom_max)
		
		if event.button_index == 4:
			camera.zoom += zoom_modifier
			camera.zoom = clamp(camera.zoom, zoom_min, zoom_max)


func _damage_multiplier_changed(value: float) -> void:
	Global.rpc("update_damage_multiplier", value)


func _change_object_view(value: bool) -> void:
	is_server_view = value
	for object: BaseObject in objects.get_children():
		object.is_server_side = is_server_view


func _spawn_enemies() -> void:
	for number: int in enemy_number:
		var aircraft: ObjectAircraft = aircraft_scene.instantiate()
		
		aircraft.name = "Aircraft" + str(number)
		objects.add_child(aircraft, true)
		
		# Randomizing x and y for aircraft position
		var x_position: float = randf_range(-aircraft_spawn_offset, aircraft_spawn_offset)
		# Will center the x position on the ship
		x_position = ship.position.x + x_position
		var y_position: float = randf_range(-aircraft_spawn_offset, aircraft_spawn_offset)
		# Will center the y position on the ship
		y_position = ship.position.y + y_position
		var aircraft_position: Vector2 = Vector2(x_position, y_position)
		# setting aircraft position
		aircraft.position = aircraft_position
		aircraft.init(ship, aircraft_spawn_offset)
		
		# Generates altitude
		var aircraft_altitude: float = randf_range(
			aircraft_altitude_range.x, aircraft_altitude_range.y)
		
		aircraft.altitude = aircraft_altitude
		aircraft.type = BaseObject.Type.UNIDENTIFIED
		
		aircraft.is_server_side = is_server_view
		
		aircraft.object_destroyed.connect(_object_destroyed)
