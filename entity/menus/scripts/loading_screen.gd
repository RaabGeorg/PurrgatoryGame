extends Control

var target_scene_path: String
var progress = []
var has_finished_loading: bool = false

@onready var progress_bar = $ProgressBar
@onready var status_label = $StatusLabel

func _ready() -> void:
	#set default
	status_label.text = "Loading..."
	progress_bar.value = 0
	
	#check if path is provided
	if target_scene_path != "":
		#start background loading
		var error = ResourceLoader.load_threaded_request(target_scene_path)
		if error != OK:
			status_label.text = "Error: Could not find scene file."
	else:
		status_label.text = "Error: No target scene path set."
		
func _process(_delta):
	if has_finished_loading:
		return

	var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	progress_bar.value = progress[0] * 100
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			pass
			
		ResourceLoader.THREAD_LOAD_LOADED:
			has_finished_loading = true
			status_label.text = "Press Any Key to Continue"
			progress_bar.value = 100
			
		ResourceLoader.THREAD_LOAD_FAILED:
			status_label.text = "Error: Loading failed."
		
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
			status_label.text = "Error: Invalid resource path."

func _input(event):
	if has_finished_loading:
		if event is InputEventKey or event is InputEventMouseButton:
			if event.is_pressed():
				_switch_to_game()

func _switch_to_game():
	var new_scene = ResourceLoader.load_threaded_get(target_scene_path)
	
	get_tree().change_scene_to_packed(new_scene)
