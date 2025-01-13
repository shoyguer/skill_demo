@tool
class_name ObjectAircraft
extends BaseObject


const MIN_DESTINATION_DISTANCE: float = 1.0

var destination: Vector2 = Vector2.ZERO
var central_position: Vector2 = Vector2.ZERO
var central_offset: float

var can_travel: bool = false


func _physics_process(delta: float) -> void:
	if can_travel and multiplayer.is_server():
		global_position = global_position.move_toward(destination, object_speed * delta)
		
		var distance: float = global_position.distance_to(destination)
		if distance <= MIN_DESTINATION_DISTANCE:
			can_travel = false
			
			if is_server_side:
				generate_destination()


func init(ship: ObjectShip, offset: float) -> void:
	central_position = ship.global_position
	central_offset = offset
	generate_destination()


func generate_destination() -> void:
	# Randomizing x and y for aircraft position
	var x_position: float = randf_range(-central_offset, central_offset)
	# Will center the x position on the ship
	x_position = central_position.x + x_position
	var y_position: float = randf_range(-central_offset, central_offset)
	# Will center the y position on the ship
	y_position = central_position.y + y_position
	
	destination = Vector2(x_position, y_position)
	
	sprite.look_at(destination)
	can_travel = true
