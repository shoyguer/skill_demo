class_name GameLoop
extends Node2D
## The [GameLoop] is just a base class that will be inherited by other classes.


var is_server_side: bool = true
var damage_multiplier: float = 1.0

@onready var hud: HUD = %HUD
@onready var objects: Node2D = %Objects
@onready var ship: ObjectShip = %Ship
@onready var camera: Camera2D = %Camera


func _ready() -> void:
	for object: BaseObject in objects.get_children():
		object.is_server_side = is_server_side
