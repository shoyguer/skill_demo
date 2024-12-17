class_name MainMenu
extends Control
## This will control the Main Menu for the game. [br]
## It is the first scene loaded when the game is openned.


enum State {
	MAIN_MENU,
	MULTIPLAYER
}

enum Fade {
	IN, OUT
}

## Time it takes for the whole fading in or out animation.
@export var fade_time: float = 0.5

var state: State = State.MAIN_MENU
var current_container: VBoxContainer = null

# Containers
@onready var main_menu_container: VBoxContainer = %MainMenuContainer
@onready var multi_player_container: VBoxContainer = %MultiPlayerContainer
@onready var multi_player_buttons: VBoxContainer = %MultiPlayerButtons
# Buttons
@onready var button_host_server: UIButton = %ButtonHostServer
@onready var button_join_server: UIButton = %ButtonJoinServer
# Username related
@onready var username_line: LineEdit = %UsernameLine
@onready var button_send: Button = %ButtonSend
# Game data
@onready var game_version_label: Label = %GameVersionLabel


## When this scene is fully loaded (and all it's nodes), this script will run.
func _ready() -> void:
	multi_player_container.hide()
	multi_player_container.modulate.a = 0
	current_container = main_menu_container
	main_menu_container.show()
	
	button_host_server.disabled = true
	button_join_server.disabled = true
	
	#region Button pressed signal connection
	# Connects all the main_menu_container buttons button_got_pressed signals.
	for button: UIButton in main_menu_container.get_children():
		button.button_got_pressed.connect(_menu_button_pressed)
	
	# Connects all the multi_player_container buttons button_got_pressed signals.
	for button: UIButton in multi_player_buttons.get_children():
		button.button_got_pressed.connect(_menu_button_pressed)
	#endregion
	
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


## When a [UIButton], child of the [member main_menu_container] is pressed, this function will run
## to decide what will happen.
func _menu_button_pressed(button: UIButton) -> void:
	match button.button_type:
		button.ButtonType.MULTIPLAYER:
			_menu_state_manager(State.MULTIPLAYER)
		
		button.ButtonType.BACK:
			_menu_state_manager(State.MAIN_MENU)
		
		button.ButtonType.QUIT_GAME:
			get_tree().quit()
		
		button.ButtonType.HOST_SERVER:
			MultiplayerManager.host_game()
			SceneLoader.load_scene(button.scene_path_to_load)
		
		button.ButtonType.JOIN_SERVER:
			MultiplayerManager.join_game()
			SceneLoader.load_scene(button.scene_path_to_load)
		
		_:
			if button.scene_path_to_load != "":
				SceneLoader.load_scene(button.scene_path_to_load)


## Menu State Manager, also sets fade in and out animations.
func _menu_state_manager(new_state: State) -> void:
	state = new_state
	
	# Hides old VBoxContainer, Fade Out animation.
	await _fade_container(current_container, Fade.OUT)
	# Little timer
	await get_tree().create_timer(0.25).timeout
	
	# Sets new VBoxContainer then shows it.
	current_container = main_menu_container
	
	# For setting the current_container, then it will fade in the new current_container.
	match new_state:
		State.MAIN_MENU:
			# Sets new VBoxContainer
			current_container = main_menu_container
		
		State.MULTIPLAYER:
			# Sets new VBoxContainer
			current_container = multi_player_container
	
	# Fade In animation
	await _fade_container(current_container, Fade.IN)


## Function that will tween fade in and out animations for the containers containing [UIButton]s.
func _fade_container(container: VBoxContainer, type: Fade) -> void:
	var tween = get_tree().create_tween()
	
	match type:
		Fade.IN:
			container.show()
			tween.tween_property(container, "modulate:a", 1, fade_time)
			await tween.finished
			return
		
		Fade.OUT:
			tween.tween_property(container, "modulate:a", 0, fade_time)
			tween.tween_callback(func():
				container.hide()
				)
			await tween.finished
			return


## When [member button_send] is pressed, the username will be saved.
func _on_username_send_pressed() -> void:
	if username_line.text != "":
		MultiplayerManager.user_name = username_line.text
		button_host_server.disabled = false
		button_join_server.disabled = false
	
	else:
		button_host_server.disabled = true
		button_join_server.disabled = true
