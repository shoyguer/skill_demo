@tool
class_name OptionCheckContainer
extends HBoxContainer
## This will be used as a way to change a bool value, chaging some other
## variable in the game.


#region Variable Declaration
signal button_toggled(type: bool)

## Sets the title of the option.
@export var label_title: String = "Label":
	set(value):
		label_title = value
		
		if label is Label:
			label.text = label_title
	get:
		return label_title
## Sets the default value. This value will be used if the user doesn't change it.
@export var check_value: bool = false:
	set(value):
		check_value = value
		if check is CheckButton:
			check.button_pressed = check_value
			# Emits it's value
			button_toggled.emit(check_value)
	get:
		return check_value

@onready var label: Label = %Label
@onready var check: CheckButton = %Check
#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_title = label_title
	check_value = check_value


## When the check button is pressed, check_value will also be changed.
func _on_check_toggled(toggled_on: bool) -> void:
	check_value = toggled_on
