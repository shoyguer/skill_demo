@tool
class_name OptionEnumContainer
extends HBoxContainer
## This will be used as a way to change a float value, chaging some other
## variable in the game.


#region Variable Declaration
signal type_changed(type: BaseObject.Type)

## Sets the title of the option.
@export var label_title: String = "Label":
	set(value):
		label_title = value
		
		if label is Label:
			label.text = label_title
	get:
		return label_title
## Sets the default value. This value will be used if the user doesn't change it.
@export var line_value: BaseObject.Type:
	set(value):
		line_value = value
		
		if line is LineEdit:
			line.text = BaseObject.Type.find_key(line_value)
			# Emits it's value
			type_changed.emit(line_value)
	get:
		return line_value
@export var editable: bool = true:
	set(value):
		editable = value
		
		if button_back is Button and button_next is Button:
			if editable:
				button_back.disabled = false
				button_next.disabled = false
			else:
				button_back.disabled = true
				button_next.disabled = true
		
	get:
		return editable

var type_size: int

@onready var button_back: Button = %ButtonBack
@onready var button_next: Button = %ButtonNext

@onready var label: Label = %Label
@onready var line: LineEdit = %Line
#endregion


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label_title = label_title
	line_value = line_value
	editable = editable
	
	type_size = BaseObject.Type.size()


func _on_button_back_pressed() -> void:
	if line_value == 0:
		line_value = type_size - 1 as BaseObject.Type
	else:
		# Aux int value so there are no errors because the line_value is a Enum
		var aux_line_value: int = line_value - 1
		# Casting the aux_line_value as BaseObject.Type so no warnings appear
		line_value = aux_line_value as BaseObject.Type
	
	line.text = BaseObject.Type.find_key(line_value)


func _on_button_next_pressed() -> void:
	if line_value == type_size - 1:
		line_value = 0 as BaseObject.Type
	else:
		# Aux int value so there are no errors because the line_value is a Enum
		var aux_line_value: int = line_value + 1
		# Casting the aux_line_value as BaseObject.Type so no warnings appear
		line_value = aux_line_value as BaseObject.Type
	
	line.text = BaseObject.Type.find_key(line_value)
