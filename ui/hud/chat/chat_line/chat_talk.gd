class_name ChatTalk
extends ChatEvent


@onready var rich_text: RichTextLabel = $RichText


## Sets the message a user sent in the Chat
func _set_message(user_id: int, message: String) -> void:
	rich_text.text = str(user_id) + ": " + message
