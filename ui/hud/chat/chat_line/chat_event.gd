class_name ChatEvent
extends HBoxContainer


@onready var label: Label = $Label


func _ready() -> void:
	MultiplayerManager.event_happened.connect(_set_text)


## Sets the a event, such as joined or exited.
func _set_text(user_id: int, event: MultiplayerManager.Event) -> void:
	match event:
		MultiplayerManager.Event.JOINED:
			label.text = str(user_id) + " just joined!"
		
		MultiplayerManager.Event.EXITED:
			label.text = str(user_id) + " just exited!"
