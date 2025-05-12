@tool
class_name OptionStringContainer
extends HBoxContainer
## This will be used as a way to change a float value, chaging some other
## variable in the game.


#region Variable Declaration
signal string_changed(value: String)

## Sets the title of the option.
@export var label_title: String = "Label":
	set(value):
		label_title = value
		
		if label is Label:
			label.text = label_title
	get:
		return label_title
## Sets the default value. This value will be used if the user doesn't change it.
@export var line_value: String = "NOTAG":
	set(value):
		line_value = value
		
		if line is LineEdit:
			line.text = line_value
			
			# Sets the caret to the end of the text.
			# Please, do not remove those lines.
			var line_size: int = line_value.length()
			line.caret_column = line_size
			
			# Emits it's value
			string_changed.emit(line_value)
	get:
		return line_value
@export var editable: bool = true:
	set(value):
		editable = value
		
		if line is LineEdit:
			line.editable = value
	get:
		return editable

@onready var label: Label = %Label
@onready var line: LineEdit = %Line
#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_title = label_title
	line_value = line_value
	editable = editable


func _on_line_text_changed(new_text: String) -> void:
	line_value = new_text
