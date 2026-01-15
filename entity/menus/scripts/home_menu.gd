extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://entity/menus/save_menu.tscn")
	#var load_screen = load("res://entity/menus/loading_screen.tscn").instantiate()
	#load_screen.target_scene_path = "res://root.tscn"
	#get_tree().root.add_child(load_screen)
	#self.queue_free()

func _on_options_2_pressed() -> void:
	get_tree().change_scene_to_file("res://entity/menus/save_menu.tscn")


func _on_exit_3_pressed() -> void:
	get_tree().quit()


func _on_start_mouse_exited() -> void:
	$VBoxContainer/Start.release_focus()


func _on_options_mouse_exited() -> void:
	$VBoxContainer/Options.release_focus()


func _on_exit_mouse_exited() -> void:
	$VBoxContainer/Exit.release_focus()
