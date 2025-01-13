class_name GameLoop
extends Node2D
## The [GameLoop] is just a base class that will be inherited by other classes.


signal object_added(object: BaseObject)
signal object_removed(object: BaseObject)

@export var score_points: int = 0:
	set(value):
		score_points = value
		
		if label_points is Label:
			label_points.text = str(score_points)
	get:
		return score_points

@export var aircraft_scene: PackedScene
@export var missile_low_scene: PackedScene
@export var missile_high_scene: PackedScene

var is_server_side: bool = true
var interactable_objects: Array[BaseObject] = []

@onready var label_score: Label = %LabelScore
@onready var label_points: Label = %LabelPoints

@onready var hud: HUD = %HUD
@onready var objects: Node2D = %Objects
@onready var ship: ObjectShip = %Ship
@onready var camera: Camera2D = %Camera


func _ready() -> void:
	randomize()
	
	for object: BaseObject in objects.get_children():
		object.is_server_side = is_server_side


func _on_object_spawner_spawned(node: Node) -> void:
	node.is_server_side = is_server_side
	interactable_objects.append(node)
	object_added.emit(node)


func _object_destroyed(object: BaseObject) -> void:
	var points: int = score_points + 1
	
	object.queue_free()
	
	rpc("_update_score_points", points)


@rpc("authority", "call_local")
func _update_score_points(points: int) -> void:
	score_points = points


func _on_object_spawner_despawned(node: Node) -> void:
	interactable_objects.erase(node)
	object_removed.emit(node)


@rpc("any_peer", "call_remote")
func _shoot_missile(type: ObjectMissile.MissileType, object_name: String) -> void:
	for object: BaseObject in objects.get_children():
		if object.name == object_name:
			
			var missile: ObjectMissile
			
			match type:
				ObjectMissile.MissileType.LOW:
					missile = missile_low_scene.instantiate()
				
				ObjectMissile.MissileType.HIGH:
					missile = missile_high_scene.instantiate()
			
			var randi_var: int = randi_range(1, 16000)
			
			missile.name = "Missile" + str(randi_var)
			objects.add_child(missile, true)
			
			# setting missile position
			missile.position = ship.global_position
			
			missile.is_server_side = is_server_side
			
			missile.leaves_trail = true
			missile.trail_create_time = 3
			
			missile.init(object)
			
			break
