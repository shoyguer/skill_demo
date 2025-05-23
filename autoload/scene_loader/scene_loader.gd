extends Control
## Is responsible for loading new scenes, showing a loading bar to the user.


var progress: Array = []
var scene_to_load: String = ""
var scene_load_status: int = 0
var loading: bool = false

@onready var percentage_label: Label = %PercentageLabel


## When this scene is fully loaded (and all it's nodes), this script will run.
func _ready() -> void:
	hide()


## The code inside this function will run every single game frame.
func _process(_delta: float) -> void:
	# If the scene is loading, the code will run
	if loading == true:
		scene_load_status = ResourceLoader.load_threaded_get_status(scene_to_load, progress)
		percentage_label.text = str(progress[0] * 100) + "%"
		
		if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
			loading = false
			var new_scene = ResourceLoader.load_threaded_get(scene_to_load)
			
			# If game is paused, unpause it
			if get_tree().paused == true:
				get_tree().paused = false
			
			hide()
			get_tree().change_scene_to_packed(new_scene)


## When needed, the server can request for one of the peers connected to the server
## to load a specific scene.
@rpc("authority", "call_remote")
func remote_load_scene(new_scene_path: String) -> void:
	load_scene(new_scene_path)


## Loads a new scene, according to the scene path, set by the [param new_game_scene].
func load_scene(new_scene_path: String) -> void:
	scene_to_load = new_scene_path
	ResourceLoader.load_threaded_request(scene_to_load)
	loading = true
	show()
