@tool
class_name BaseObject
extends StaticBody2D


#region Variable Declaration
signal object_updated(object: BaseObject)
signal object_destroyed(object: BaseObject)

enum Type {
	UNIDENTIFIED,
	FRIEND,
	HOSTILE
}

#region Object Properties Group
@export_group("Object Properties")
@export var tag: String = "NOTAG":
	set(value):
		tag = value
		
		if label_tag is Label:
			label_tag.text = tag
	get:
		return tag
## The Object's "health"
@export var max_hit_points: int = 10
@export var current_hit_points: int = max_hit_points:
	set(value):
		current_hit_points = value
		current_hit_points = clampi(current_hit_points, 0, max_hit_points)
		
	get:
		return current_hit_points
## How much damage this object will do to another
@export var damage_points: int = 0
## How fast is this object, while moving.
@export var object_speed: float = 1.0
## If this object can be hovered over, and interacted with (adding tags).
@export var can_be_interacted: bool = false
@export var show_hud: bool = false:
	set(value):
		show_hud = value
		
		if (
			hud is Control
			and show_hud
		):
			hud.show()
		
		if (
			hud is Control
			and not show_hud
		):
			hud.hide()
	get:
		return show_hud
@export var type: Type = Type.UNIDENTIFIED:
	set(value):
		type = value
		
		# Matches the type to show the correct ntds texture.
		if not is_server_side:
			
			_hide_ntds()
			
			match type:
				Type.UNIDENTIFIED:
					ntds_unidentified.show()
				Type.FRIEND:
					ntds_friend.show()
				Type.HOSTILE:
					ntds_hostile.show()
	get:
		return type
@export var can_change_type: bool = true

## The altitude of the object
@export var altitude: float = 0:
	set(value):
		altitude = value
		
		if label_altitude is Label:
			label_altitude.text = "ALT: " + str(int(altitude))
	get:
		return altitude
#endregion

#region Visual Group
@export_group("Visual")
@export_subgroup("NTDS")
@export var ntds_friend_texture: Texture:
	set(value):
		ntds_friend_texture = value
		
		if ntds_friend is Sprite2D:
			ntds_friend.texture = ntds_friend_texture
			ntds_friend.scale = ntds_scale
		
	get:
		return ntds_friend_texture
@export var ntds_unidentified_texture: Texture:
	set(value):
		ntds_unidentified_texture = value
		
		if ntds_unidentified is Sprite2D:
			ntds_unidentified.texture = ntds_unidentified_texture
			ntds_unidentified.scale = ntds_scale
		
	get:
		return ntds_unidentified_texture
@export var ntds_hostile_texture: Texture: 
	set(value):
		ntds_hostile_texture = value
		
		if ntds_hostile is Sprite2D:
			ntds_hostile.texture = ntds_hostile_texture
			ntds_hostile.scale = ntds_scale
		
	get:
		return ntds_hostile_texture

@export var ntds_position: Vector2 = Vector2.ZERO:
	set(value):
		ntds_position = value
		
		if (
			not is_server_side
			and ntds_friend is Sprite2D
			and ntds_unidentified is Sprite2D
			and ntds_hostile is Sprite2D
		):
			ntds_friend.offset = ntds_position
			ntds_hostile.offset = ntds_position
			ntds_unidentified.offset = ntds_position
		
	get:
		return ntds_position
@export var ntds_scale: Vector2 = Vector2(1.0, 1.0):
	set(value):
		ntds_scale = value
		
		if (
			not is_server_side
			and ntds_friend is Sprite2D
			and ntds_hostile is Sprite2D
			and ntds_unidentified is Sprite2D
		):
			ntds_friend.scale = ntds_scale
			ntds_hostile.scale = ntds_scale
			ntds_unidentified.scale = ntds_scale
		
	get:
		return ntds_scale
#endregion

@export_subgroup("Server")
@export var server_texture: Texture:
	set(value):
		server_texture = value
		
		if (
			is_server_side
			and sprite is Sprite2D
		):
			sprite.texture = server_texture
			sprite.scale = server_scale
		
	get:
		return server_texture
@export var server_scale: Vector2 = Vector2(1.0, 1.0):
	set(value):
		server_scale = value
		
		if (
			is_server_side
			and sprite is Sprite2D
		):
			sprite.scale = server_scale
		
	get:
		return server_scale
@export var is_server_side: bool = true:
	set(value):
		is_server_side = value
		
		if (
			is_server_side
			and sprite is Sprite2D
		):
			sprite.show()
			_hide_ntds()
		
		if (
			not is_server_side
			and sprite is Sprite2D
		):
			sprite.hide()
			# Because inside the set of the type, is a match for showing the correct
			# ntds sprite.
			type = type
		
	get:
		return is_server_side

@export_subgroup("Collision")
@export var collision_shape_size: Vector2:
	set(value):
		collision_shape_size = value
		
		if collision is CollisionShape2D:
			collision.shape.size = collision_shape_size
	get:
		return collision_shape_size

@export var area_collision_shape_size: Vector2:
	set(value):
		area_collision_shape_size = value
		
		if area_collision is CollisionShape2D:
			area_collision.shape.size = area_collision_shape_size
	get:
		return area_collision_shape_size

var ntds_array: Array[Sprite2D] = []

#region Onready vars
@onready var collision: CollisionShape2D = $Collision
@onready var area_collision: CollisionShape2D = %AreaCollision
@onready var sprite: Sprite2D = $Sprite
@onready var label_hp: Label = %LabelHP
@onready var label_tag: Label = %LabelTag
@onready var label_altitude: Label = %LabelAltitude
@onready var hud: Control = %HUD

# NTDS sprites
@onready var ntds_friend: Sprite2D = $NTDSFriend
@onready var ntds_hostile: Sprite2D = $NTDSHostile
@onready var ntds_unidentified: Sprite2D = $NTDSUnidentified
#endregion
#endregion


func _ready() -> void:
	tag = tag
	
	can_be_interacted = can_be_interacted
	show_hud = show_hud
	
	# Needs to be set before the textures and type, so they can be utilized in the
	# "set" for the variable.
	ntds_array = [ntds_friend, ntds_hostile, ntds_unidentified]
	
	# NTDS variables
	ntds_friend_texture = ntds_friend_texture
	ntds_hostile_texture = ntds_hostile_texture
	ntds_unidentified_texture = ntds_unidentified_texture
	
	ntds_position = ntds_position
	ntds_scale = ntds_scale
	
	type = type
	
	# Server variables
	server_texture = server_texture
	server_scale = server_scale
	is_server_side = is_server_side
	
	# Collision variables
	collision_shape_size = collision_shape_size
	area_collision_shape_size = area_collision_shape_size


func _hide_ntds() -> void:
	for ntds: Sprite2D in ntds_array:
		ntds.hide()


func _on_mouse_entered() -> void:
	if can_be_interacted:
		show_hud = true


func _on_mouse_exited() -> void:
	if can_be_interacted:
		show_hud = false


func object_update_server() -> void:
	var data: Dictionary = {
		"tag": tag,
		"type": type,
		"current_hit_points": current_hit_points
	}
	
	rpc_id(1, "_update_server", data)


func get_hit(damage: int) -> void:
	if is_server_side:
		var health_damage: int = int(damage * Global.damage_multiplier)
		current_hit_points -= health_damage
	
	if current_hit_points <= 0:
		object_destroyed.emit(self)
	
	label_hp.text = str(current_hit_points)


@rpc("any_peer", "call_remote")
func _update_server(data: Dictionary) -> void:
	tag = data.tag
	type = data.type
	current_hit_points = data.current_hit_points
	
	rpc("_update_object")


@rpc("authority", "call_remote")
func _update_object() -> void:
	object_updated.emit(self)
