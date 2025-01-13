@tool
class_name ObjectMissile
extends BaseObject


var target: BaseObject = null

var can_travel: bool = false


func _physics_process(delta: float) -> void:
	if can_travel and multiplayer.is_server():
		global_position = global_position.move_toward(target.global_position, object_speed * delta)
		sprite.look_at(target.global_position)


func init(new_target: BaseObject) -> void:
	target = new_target
	
	can_travel = true


func _on_area_area_entered(area: Area2D) -> void:
	if is_server_side:
		if area.get_parent() == target:
			target.get_hit(damage_points)
			self.queue_free()
