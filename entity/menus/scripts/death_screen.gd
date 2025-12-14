extends Control

func _on_quit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://entity/menus/home_menu.tscn")


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://root.tscn")


func _on_options_pressed() -> void:
	print("options was pressed")
