class_name HUD
extends CanvasLayer


@export var chat_message_object: PackedScene

@onready var button_send: Button = %ButtonSend
@onready var message_line: LineEdit = %MessageLine
@onready var messages: VBoxContainer = %Messages
@onready var messages_scroll: ScrollContainer = %MessagesScroll


func _ready() -> void:
	button_send.pressed.connect(_send_message)
	MultiplayerManager.event_happened.connect(_event_happened)


func _event_happened(user: String, event: MultiplayerManager.Event) -> void:
	rpc("message_event", user, event)


func _send_message() -> void:
	# If there is no message, just return.
	if message_line.text == "": return
	
	var text: String = message_line.text
	# Resets the message_line
	message_line.text = ""
	rpc("message_talk", MultiplayerManager.user_name, text)


@rpc("any_peer", "call_local")
func message_event(username: String, event: MultiplayerManager.Event) -> void:
	var message: ChatMessage = chat_message_object.instantiate()
	messages.add_child(message)
	
	message.set_event(username, event)


@rpc("any_peer", "call_local")
func message_talk(username: String, text: String) -> void:
	var message: ChatMessage = chat_message_object.instantiate()
	messages.add_child(message)
	
	message.set_message(username, text)
