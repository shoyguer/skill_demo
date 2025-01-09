class_name GameLoop
extends Node2D
## The [GameLoop] is just a base class that will be inherited by other classes.


var is_server_side: bool = true

@onready var hud: HUD = %HUD
@onready var objects: Node2D = %Objects


func _ready() -> void:
	for object: BaseObject in objects.get_children():
		object.is_server_side = is_server_side
