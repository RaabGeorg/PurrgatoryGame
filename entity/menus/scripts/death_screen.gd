extends Control

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://entity/menus/home_menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://root.tscn")


func _on_options_pressed() -> void:
	print("options was pressed")


func _on_restart_mouse_exited() -> void:
	$VBoxContainer/Restart.release_focus()


func _on_options_mouse_exited() -> void:
	$VBoxContainer/Options.release_focus()


func _on_quit_to_menu_mouse_exited() -> void:
	$VBoxContainer/Quit_to_menu.release_focus()
