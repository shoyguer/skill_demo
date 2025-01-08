class_name HUD
extends CanvasLayer
## This class is responsible for handling all the chat messages.


## [ChatMessage] [PackedScene] to be instantiated.
@export var chat_message_object: PackedScene

@onready var button_send: Button = %ButtonSend
@onready var message_line: LineEdit = %MessageLine
@onready var messages: VBoxContainer = %Messages
@onready var messages_scroll: ScrollContainer = %MessagesScroll


func _ready() -> void:
	button_send.pressed.connect(_send_message)
	MultiplayerManager.event_happened.connect(_event_happened)


## When some event happends, this will trigger a message. This function is just a bridge.
func _event_happened(user: String, event: MultiplayerManager.Event) -> void:
	_message_event(user, event)


## For sendind the current written message to the distribution [method _message_distribution_server].
## Only the host will receive it, then distribute to all peers connected, using the
## [method _message_talk] function.
func _send_message() -> void:
	# If there is no message, just return.
	if message_line.text == "": return
	
	var text: String = message_line.text
	# Resets the message_line
	message_line.text = ""
	rpc_id(1, "_message_distribution_server", MultiplayerManager.username, text)


## Will distribute the message to all peers connected to the server.
@rpc("any_peer", "call_local")
func _message_distribution_server(username: String, text: String) -> void:
	print("Got here?")
	rpc("_message_talk", username, text)


## Instantiates a new [ChatMessage], then shows up message to players connected.
@rpc("authority", "call_local")
func _message_talk(username: String, text: String) -> void:
	var message: ChatMessage = chat_message_object.instantiate()
	messages.add_child(message)
	
	message.set_message(username, text)


## Instantiates [ChatMessage], then shows up event 
## [member MultiplayerManager.Event.JOINED] 
## or [member MultiplayerManager.Event.EXITED] to all players connected.
func _message_event(username: String, event: MultiplayerManager.Event) -> void:
	var message: ChatMessage = chat_message_object.instantiate()
	messages.add_child(message)
	
	message.set_event(username, event)
