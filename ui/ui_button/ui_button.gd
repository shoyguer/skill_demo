@tool
class_name UIButton
extends Button
## This type of button will only be used in UI scenes, such as the [MainMenu] or
## TODO - In game Menu.


## When the button gets pressed, this function will be emitted by the [method _button_pressed].
## We use a custom signal instead of the [signal pressed], because the button needs to be set as a
## parameter to be used by the parent scene, since some of it's variables can be used.
signal button_got_pressed(button: UIButton)

enum ButtonType {
	RESUME,
	NEW_GAME,
	LOAD_GAME,
	SETTINGS,
	RESTART,
	QUIT_MENU,
	QUIT_GAME
}

## The button type. It will define what will happen to the parent scene after this [UIButton]
## is pressed.
@export var button_type: ButtonType
## You can just drag and drop the [PackedScene] here, and it will automatically set
## the [member scene_path_to_load]. By doing so, this variable will still be empty. [br]
## This variable NEEDS to stay empty, otherwise, it will load the whole scene for
## every button, and take memory (and the [SceneLoader] will have no point in existing).
@export var scene_to_load: PackedScene:
	set(value):
		if (scene_path_to_load is String) and (value != null):
			scene_path_to_load = value.resource_path
	get:
		return scene_to_load
## The scene path that will be loaded inside the [SceneLoader].
@export var scene_path_to_load: String


## When this scene is fully loaded (and all it's nodes), this script will run.
func _ready() -> void:
	scene_to_load = scene_to_load


## After this button is pressed, it will emit the [signal button_got_pressed] custom signal,
## that will be used by the parent scene.
func _button_pressed() -> void:
	button_got_pressed.emit(self)
