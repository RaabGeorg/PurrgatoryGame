extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://entity/menus/home_menu.tscn")
	
	
	
func _on_save_1_pressed() -> void:
	launch_game(1)


func _on_save_2_pressed() -> void:
	launch_game(2)


func _on_save_3_pressed() -> void:
	launch_game(3)

	
func start_agme_with_slot(slot: int):
	SaveManager.current_slot = slot
	get_tree().change_scene_to_file("res://root.tscn")

func launch_game(slot: int) -> void:
	SaveManager.current_slot = slot
	var load_screen = load("res://entity/menus/loading_screen.tscn").instantiate()
	load_screen.target_scene_path = "res://root.tscn"
	get_tree().root.add_child(load_screen)
	self.queue_free()
	


func _on_save_1_mouse_exited() -> void:
	$"VBoxContainer/Save 1".release_focus()


func _on_save_2_mouse_exited() -> void:
	$"VBoxContainer/Save 2".release_focus()


func _on_save_3_mouse_exited() -> void:
	$"VBoxContainer/Save 3".release_focus()


func _on_back_mouse_exited() -> void:
	$VBoxContainer/Back.release_focus()
