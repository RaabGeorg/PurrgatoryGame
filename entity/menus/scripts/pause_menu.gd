extends Control
var is_open = false
func _ready() -> void:
	hide()
	get_tree().paused = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("openPause") and not get_tree().current_scene.name=="HomeMenu":
		if get_tree().paused and get_tree().current_scene.get_child(0).get_children().size() == 1 or visible == true:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()
		
	
func resume() -> void:
	print("resume was pressed")
	if get_tree().current_scene.get_child(0).get_children().size() == 1:
		get_tree().paused = false
	hide()

func pause() -> void:
	print("yippie pause was pressed")
	show()
	if get_tree().current_scene.get_child(0).get_children().size() == 1:
		get_tree().paused = true
	
	
func _on_save_pressed() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		SaveManager.save_current_game(player)
	get_tree().paused = false
	hide()
	get_tree().change_scene_to_file("res://entity/menus/permanent_upgrades.tscn")

	
# -------------- BUTTON COPNNECTORS -----------------------
func _on_quit_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		SaveManager.save_current_game(player)
	
	get_tree().change_scene_to_file("res://entity/menus/home_menu.tscn")
	hide()
func _on_options_pressed() -> void:
	print("option was pressed")

func _on_resume_pressed() -> void:
	resume()



func _on_resume_mouse_exited() -> void:
	$VBoxContainer/Resume.release_focus()


func _on_options_mouse_exited() -> void:
	$VBoxContainer/Options.release_focus()


func _on_quit_mouse_exited() -> void:
	$VBoxContainer/Quit.release_focus()


func _on_save_mouse_exited() -> void:
	$VBoxContainer/Save.release_focus()
