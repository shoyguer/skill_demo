extends Node


var game_version: Dictionary = {
	"major": "0",
	"minor": "00",
	"build": "03",
	"label": "pre-alpha"}

var game_executioner_path: String = "res://scenes/game_loop/game_executioner/game_executioner.tscn"
var game_recon_path: String = "res://scenes/game_loop/game_recon/game_recon.tscn"

var damage_multiplier: float = 1


@rpc("authority", "call_local")
func update_damage_multiplier(new_value: float) -> void:
	damage_multiplier = new_value
