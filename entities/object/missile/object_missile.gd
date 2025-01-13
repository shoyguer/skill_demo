@tool
class_name ObjectMissile
extends BaseObject


enum MissileType {
	LOW,
	HIGH
}

var target: BaseObject = null

var can_travel: bool = false
var correct_altitude: bool = false


func _physics_process(delta: float) -> void:
	if can_travel and multiplayer.is_server():
		if  target != null and altitude != target.altitude:
			altitude = move_toward(altitude, target.altitude, (object_speed * 100) * delta)
		else:
			correct_altitude = true
		
		sprite.look_at(target.global_position)
		
		if correct_altitude:
			global_position = global_position.move_toward(target.global_position, object_speed * delta)


func init(new_target: BaseObject) -> void:
	target = new_target
	
	target.object_updated.connect(_target_updated)
	target.object_destroyed.connect(_target_destroyed)
	
	can_travel = true


func _target_updated() -> void:
	print("test?")
	if target.type == BaseObject.Type.FRIEND:
		queue_free()


func _target_destroyed() -> void:
	queue_free()


func _on_area_area_entered(area: Area2D) -> void:
	if multiplayer.is_server():
		if area.get_parent() == target:
			target.get_hit(damage_points)
			self.queue_free()
