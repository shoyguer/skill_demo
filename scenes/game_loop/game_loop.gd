class_name GameLoop
extends Node2D


@onready var hud: HUD = %HUD


func _ready() -> void:
	hud.message_event(MultiplayerManager.user_name, MultiplayerManager.Event.JOINED)
