@tool
class_name BaseObject
extends StaticBody2D


#region Variable Declaration
@export_group("Object Properties")
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
@export var can_be_interacted: bool = false:
	set(value):
		can_be_interacted = value
		
		# If can_be_interacted == false, then the hud will NEVER show.
		if (
			hud is Control
			and not can_be_interacted
		):
			hud.hide()
		
		else:
			# calls show_hud to make sure hud is showing IF show_hud is true.
			show_hud = show_hud
		
	get:
		return can_be_interacted
@export var show_hud: bool = false:
	set(value):
		show_hud = value
		
		if (
			hud is Control
			and can_be_interacted
			and show_hud
		):
			hud.show()
		
		if (
			hud is Control
			and can_be_interacted
			and not show_hud
		):
			hud.hide()
	get:
		return show_hud

## The elevation of the object
@export var elevation: float = 0

@export_group("Visual")
@export_subgroup("NTDS")
@export var ntds_texture: Texture:
	set(value):
		ntds_texture = value
		
		if (
			not is_server_side
			and ntds is Sprite2D
		):
			ntds.texture = ntds_texture
			ntds.scale = ntds_scale
		
	get:
		return ntds_texture
@export var ntds_unknown_texture: Texture:
	set(value):
		ntds_unknown_texture = value
		
		if (
			not is_server_side
			and ntds is Sprite2D
		):
			ntds.texture = ntds_unknown_texture
			ntds.scale = ntds_scale
		
	get:
		return ntds_unknown_texture
@export var ntds_position: Vector2 = Vector2.ZERO:
	set(value):
		ntds_position = value
		
		if (
			not is_server_side
			and ntds is Sprite2D
		):
			ntds.offset = ntds_position
			ntds_unknown.offset = ntds_position
		
	get:
		return ntds_position
@export var ntds_scale: Vector2 = Vector2(1.0, 1.0):
	set(value):
		ntds_scale = value
		
		if (
			not is_server_side
			and ntds is Sprite2D
		):
			ntds.scale = ntds_scale
			ntds_unknown.scale = ntds_scale
		
	get:
		return ntds_scale
@export var is_unknown: bool = true:
	set(value):
		is_unknown = value
		
		if ntds_unknown is Sprite2D:
			ntds_unknown.texture = ntds_unknown_texture
		
			if (
				is_unknown
				and not is_server_side
			):
				ntds_unknown.show()
				ntds.hide()
			
			if (
				not is_unknown
				and not is_server_side
			):
				ntds.show()
				ntds_unknown.hide()
		
	get:
		return is_unknown

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
			ntds.hide()
			ntds_unknown.hide()
		
		if (
			not is_server_side
			and sprite is Sprite2D
		):
			sprite.hide()
			
			# If is_unknown, will show the unknown texture
			if is_unknown:
				ntds_unknown.show()
			# If not is_unknown, will show the regular ntds texture.
			else:
				ntds.show()
		
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

#region Onready vars
@onready var collision: CollisionShape2D = $Collision
@onready var area_collision: CollisionShape2D = %AreaCollision
@onready var sprite: Sprite2D = $Sprite
@onready var ntds: Sprite2D = $NTDS
@onready var ntds_unknown: Sprite2D = $NTDSUnknown
@onready var label_hp: Label = %LabelHP
@onready var label_tag: Label = %LabelTag
@onready var hud: Control = %HUD
#endregion
#endregion


func _ready() -> void:
	can_be_interacted = can_be_interacted
	show_hud = show_hud
	
	# NTDS variables
	ntds_texture = ntds_texture
	ntds_position = ntds_position
	ntds_scale = ntds_scale
	
	# Server variables
	server_texture = server_texture
	server_scale = server_scale
	is_server_side = is_server_side
	
	# Collision variables
	collision_shape_size = collision_shape_size
	area_collision_shape_size = area_collision_shape_size


func _on_mouse_entered() -> void:
	if can_be_interacted:
		show_hud = true


func _on_mouse_exited() -> void:
	if can_be_interacted:
		show_hud = false
