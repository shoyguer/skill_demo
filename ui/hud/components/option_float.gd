@tool
class_name OptionFloatContainer
extends HBoxContainer
## This will be used as a way to change a float value, chaging some other
## variable in the game.


#region Variable Declaration
signal float_changed(value: float)

## Sets the title of the option.
@export var label_title: String = "Label":
	set(value):
		label_title = value
		
		if label is Label:
			label.text = label_title
	get:
		return label_title
## Sets the default value. This value will be used if the user doesn't change it.
@export var line_value: float = 1.0:
	set(value):
		line_value = value
		line_value = clampf(line_value, 0.1, 2.5)
		
		if line is LineEdit:
			line.text = str(line_value)
			# Emits it's value
			float_changed.emit(line_value)
	get:
		return line_value

@onready var label: Label = %Label
@onready var line: LineEdit = %Line
#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_title = label_title
	line_value = line_value


func _on_subtract_pressed() -> void:
	line_value -= 0.1


func _on_add_pressed() -> void:
	line_value += 0.1
