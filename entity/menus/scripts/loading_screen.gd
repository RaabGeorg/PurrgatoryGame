extends Control

var target_scene_path: String
var progress = []
var has_finished_loading: bool = false
var min_time_reached: bool = false

@onready var progress_bar = $ProgressBar
@onready var status_label = $StatusLabel

func _ready():
	status_label.text = "Loading..."
	progress_bar.value = 0
	
	#loading bar gets animated artificially (looks cooked otherwise)
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", 90.0, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_on_min_time_reached)
	
	if target_scene_path != "":
		ResourceLoader.load_threaded_request(target_scene_path)

func _on_min_time_reached():
	min_time_reached = true

func _process(_delta):
	if has_finished_loading:
		return

	var status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)
	
	#letzten prozente reinflanken
	var final_tween = create_tween()
	final_tween.tween_property(progress_bar, "value", 100.0, 0.3)
	
	if status == ResourceLoader.THREAD_LOAD_LOADED and min_time_reached:
		has_finished_loading = true
		status_label.text = "Press Any Key to Continue"
		
		
		
func _input(event):
	if has_finished_loading and event.is_pressed():
		_switch_to_game()

func _switch_to_game():
	var packed_scene = ResourceLoader.load_threaded_get(target_scene_path)
	var map_instance = packed_scene.instantiate()
	
	get_tree().root.add_child(map_instance)
	get_tree().current_scene = map_instance
	self.queue_free()
