class_name GameRecon
extends GameLoop


var interactable_index: int = 0
var current_object: BaseObject = null

@onready var label_no_found: Label = %LabelNoFound

@onready var object_data_container: VBoxContainer = %ObjectDataContainer

@onready var option_label_container: OptionStringContainer = %OptionLabelContainer
@onready var option_enum_container: OptionEnumContainer = %OptionEnumContainer

@onready var button_back: Button = %ButtonBack
@onready var button_next: Button = %ButtonNext


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ship.type = BaseObject.Type.FRIEND
	
	is_server_side = false
	
	super()
	
	object_data_container.hide()
	
	button_back.pressed.connect(_target_before)
	button_next.pressed.connect(_target_next)
	
	object_added.connect(_check_add_object)
	object_removed.connect(_remove_object_from_interface)


func _target_before() -> void:
	label_no_found.hide()
	
	if interactable_index == 0:
		interactable_index = interactable_objects.size() - 1
	else:
		interactable_index -= 1
	
	if interactable_objects.size() > 1:
		current_object.show_hud = false
		current_object.can_be_interacted = true
		current_object.object_updated.disconnect(_object_updated)
		
		current_object = interactable_objects[interactable_index]
		_add_object_to_interface()
	
	else:
		label_no_found.show()


func _target_next() -> void:
	label_no_found.hide()
	
	if interactable_index == interactable_objects.size() - 1:
		interactable_index = 0
	else:
		interactable_index += 1
	
	if interactable_objects.size() > 1:
		current_object.show_hud = false
		current_object.can_be_interacted = true
		current_object.object_updated.disconnect(_object_updated)
		
		current_object = interactable_objects[interactable_index]
		_add_object_to_interface()
	
	else:
		label_no_found.show()


func _check_add_object(object: BaseObject) -> void:
	if current_object == null:
		current_object = object
		_add_object_to_interface()


func _object_updated(object: BaseObject) -> void:
	if object == current_object:
		_add_object_to_interface()


func _add_object_to_interface() -> void:
	label_no_found.hide()
	
	current_object.show_hud = true
	current_object.can_be_interacted = false
	
	if not current_object.object_updated.is_connected(_object_updated):
		current_object.object_updated.connect(_object_updated)
	
	_show_recon_setup(true)
	
	if not current_object.can_change_type:
		option_enum_container.editable = false
	
	option_label_container.line_value = current_object.tag
	option_enum_container.line_value = current_object.type


func _show_recon_setup(type: bool) -> void:
	if type:
		object_data_container.show()
	
	else:
		object_data_container.hide()


func _remove_object_from_interface(object: BaseObject) -> void:
	if current_object == object:
		if interactable_objects.size() > 0:
			interactable_index = 0
			current_object = interactable_objects[interactable_index]
		else:
			object_data_container.hide()


## Saves the current data to the object
func _on_button_save_pressed() -> void:
	current_object.tag = option_label_container.line_value
	current_object.type = option_enum_container.line_value
	
	current_object.object_update_server()
