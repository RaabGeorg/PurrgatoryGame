extends Control

func _ready() -> void:
	hide()
	get_tree().paused = false
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("openPause"):
		print("--- PAUSE WAS PRESSED AMK ---")
		
		if get_tree().paused:
			resume()
		else:
			pause()
		get_viewport().set_input_as_handled()
		
	
func resume() -> void:
	print("resume was pressed")
	get_tree().paused = false
	hide()

func pause() -> void:
	print("yippie pause was pressed")
	show()
	get_tree().paused = true
	
# -------------- BUTTON COPNNECTORS -----------------------
func _on_quit_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
	
	get_tree().change_scene_to_file("res://entity/menus/home_menu.tscn")
	
func _on_options_pressed() -> void:
	print("option was pressed")

func _on_resume_pressed() -> void:
	resume()
	
	
	
	
	
