class_name ChatMessage
extends HBoxContainer
## This is just a label that will display a message from a player or an event,
## such as a player connecting or disconnecting from the server.


@onready var label: RichTextLabel = $RichText


## Sets the a event, such as joined or exited.
func set_event(username: String, event: MultiplayerManager.Event) -> void:
	match event:
		MultiplayerManager.Event.JOINED:
			label.text = username + " just joined!"
		
		MultiplayerManager.Event.EXITED:
			label.text = username + " just exited!"


## Sets a message from a player.
func set_message(username: String, message: String) -> void:
	label.text = username + ": " + message
