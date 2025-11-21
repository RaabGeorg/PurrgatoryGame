extends Control

func _ready():
	# Ensure the menu is hidden and the game is unpaused when the scene starts
	hide() 
	get_tree().paused = false 

func _input(event) -> void:
	# Check ONLY for the 'escape' action press
	if event.is_action_pressed("escape"):
		
		# Check if the game is currently paused
		if get_tree().paused:
			# If paused, resume the game and hide the menu
			resume()
		else:
			# If not paused, pause the game and show the menu
			pause()
	if event.is_action_pressed("escape"):
		print("--- PAUSE MENU DETECTED ESCAPE ---") 
		# ... rest of your pause/resume logic

func resume():
	# 1. Hide the pause menu control node
	hide()
	# 2. Unpause the game tree
	get_tree().paused = false

func pause():
	# 1. Show the pause menu control node
	show()
	# 2. Pause the game tree
	get_tree().paused = true

# Connected to the "Resume" button's 'pressed' signal
func _on_resume_pressed() -> void:
	resume()

# Connected to the "Options" button's 'pressed' signal
func _on_options_pressed() -> void:
	print("Option was pressed")

# Connected to the "Quit" button's 'pressed' signal
func _on_quit_pressed() -> void:
	# Important: Unpause the game before changing scenes
	if get_tree().paused:
		get_tree().paused = false
		
	get_tree().change_scene_to_file("res://menus/home_menu.tscn")
	
