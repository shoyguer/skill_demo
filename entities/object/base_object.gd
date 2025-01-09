@tool
class_name BaseObject
extends StaticBody2D


@export var ntds_texture: Texture:
	set(value):
		ntds_texture = value
		
		if (
			not is_server_side
			and sprite is Sprite2D
		):
			sprite.texture = ntds_texture
			sprite.scale = ntds_scale
		
	get:
		return ntds_texture
@export var ntds_scale: Vector2 = Vector2(1.0, 1.0):
	set(value):
		ntds_scale = value
		
		if (
			not is_server_side
			and sprite is Sprite2D
		):
			sprite.scale = ntds_scale
		
	get:
		return ntds_scale

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
		
		if collision is CollisionShape2D:
			collision.scale = server_scale
		
	get:
		return server_scale

@export var is_server_side: bool = true:
	set(value):
		is_server_side = value
		
		if (
			is_server_side
			and sprite is Sprite2D
		):
			sprite.texture = server_texture
			sprite.scale = server_scale
			collision.scale = server_scale
		
		if (
			not is_server_side
			and sprite is Sprite2D
		):
			sprite.texture = ntds_texture
			sprite.scale = ntds_scale
		
	get:
		return is_server_side

@onready var collision: CollisionShape2D = $Collision
@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	ntds_texture = ntds_texture
	ntds_scale = ntds_scale
	server_texture = server_texture
	server_scale = server_scale
	is_server_side = is_server_side
