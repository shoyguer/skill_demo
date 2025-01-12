@tool
class_name OptionButtonContainer
extends HBoxContainer
## This will be used as a way to change a bool value, chaging some other
## variable in the game.


#region Variable Declaration
signal button_pressed()

## Sets the title of the option.
@export var label_title: String = "Label":
	set(value):
		label_title = value
		
		if label is Label:
			label.text = label_title
	get:
		return label_title

@onready var label: Label = %Label
@onready var button: Button = %Button
#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_title = label_title


## When the button is pressed, [signal button_pressed] will be emitted.
func _on_button_pressed() -> void:
	button_pressed.emit()
