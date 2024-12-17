class_name HUD
extends CanvasLayer


@export var chat_event_object: PackedScene
@export var chat_talk_object: PackedScene

@onready var button_send: Button = %ButtonSend
@onready var message_line: LineEdit = %MessageLine
@onready var messages: VBoxContainer = %Messages
@onready var messages_scroll: ScrollContainer = %MessagesScroll


func _ready() -> void:
	button_send.pressed.connect(_send_message)
	MultiplayerManager.event_happened.connect(_event_happened)


func _event_happened(user: String, event: MultiplayerManager.Event) -> void:
	rpc("_message_event", user, event)


func _send_message() -> void:
	# If there is no message, just return.
	if message_line.text == "": return
	
	var text: String = message_line.text
	# Resets the message_line
	message_line.text = ""
	rpc("_message_talk", MultiplayerManager.user_name, text)


@rpc("any_peer", "call_local")
func _message_event(user: String, event: MultiplayerManager.Event) -> void:
	pass


@rpc("any_peer", "call_local")
func _message_talk(user: String, message: String) -> void:
	pass
