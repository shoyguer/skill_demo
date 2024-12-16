class_name MainMenu
extends Control
## This will control the Main Menu for the game. [br]
## It is the first scene loaded when the game is openned.


@onready var main_menu: VBoxContainer = %MainMenu
@onready var game_version_label: Label = %GameVersionLabel


## When this scene is fully loaded (and all it's nodes), this script will run.
func _ready() -> void:
	# Connects all the main_menu buttons button_got_pressed signals.
	for button: UIButton in main_menu.get_children():
		button.button_got_pressed.connect(_menu_button_pressed)
	
	#region Set Game Version
	var game_version_label_text: String = "ver.: "
	
	# Sets game version
	for key in Global.game_version.keys():
		if (key != "major") and (key != "label"):
			game_version_label_text += "."
		if key == "label":
			game_version_label_text += "-"
		game_version_label_text += Global.game_version[key]
	
	game_version_label.text = game_version_label_text
	#endregion


## When a [UIButton], child of the [member main_menu] is pressed, this function will run
## to decide what will happen.
func _menu_button_pressed(button: UIButton) -> void:
	match button.button_type:
		
		button.ButtonType.QUIT_GAME:
			get_tree().quit()
		
		_:
			if button.scene_path_to_load != "":
				SceneLoader.load_scene(button.scene_path_to_load)
