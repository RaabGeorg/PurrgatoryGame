extends Control

@onready var save1_btn = $"VBoxContainer/Save 1"
@onready var save2_btn = $"VBoxContainer/Save 2"
@onready var save3_btn = $"VBoxContainer/Save 3"


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_button_text()
	
func update_button_text():
	var buttons = [save1_btn, save2_btn, save3_btn]
	
	for i in range(buttons.size()):
		var slot_num = i + 1
		var path = SaveManager._get_path(slot_num)
		
		if FileAccess.file_exists(path):
			buttons[i].text = "Save %d" % slot_num
		else: buttons[i].text = "Empty"
			


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://entity/menus/home_menu.tscn")
	
	
	
func _on_save_1_pressed() -> void:
	launch_game(1)


func _on_save_2_pressed() -> void:
	launch_game(2)


func _on_save_3_pressed() -> void:
	launch_game(3)
	
	
	
	
func _on_delete_1_pressed() -> void:
	if SaveManager.does_save_exist(1):
		SaveManager.delete_save(1)
		print("save deleted")
	else:
		print("No save file")
		
		
func _on_delete_2_pressed() -> void:
	if SaveManager.does_save_exist(2):
		SaveManager.delete_save(2)
		print("save deleted")
	else:
		print("No save file")

func _on_delete_3_pressed() -> void:
	if SaveManager.does_save_exist(3):
		SaveManager.delete_save(3)
		print("save deleted")
	else:
		print("No save file")
	
#func start_agme_with_slot(slot: int):
	#SaveManager.current_slot = slot
	#get_tree().change_scene_to_file("res://root.tscn")

func launch_game(slot: int) -> void:
	SaveManager.current_slot = slot
	get_tree().change_scene_to_file("res://entity/menus/permanent_upgrades.tscn")
	


func _on_save_1_mouse_exited() -> void:
	$"VBoxContainer/Save 1".release_focus()


func _on_save_2_mouse_exited() -> void:
	$"VBoxContainer/Save 2".release_focus()


func _on_save_3_mouse_exited() -> void:
	$"VBoxContainer/Save 3".release_focus()


func _on_back_mouse_exited() -> void:
	$VBoxContainer/Back.release_focus()


func _on_delete_1_mouse_exited() -> void:
	$VBoxContainer2/Delete1.release_focus()


func _on_delete_2_mouse_exited() -> void:
	$VBoxContainer2/Delete2.release_focus()


func _on_delete_3_mouse_exited() -> void:
	$VBoxContainer2/Delete3.release_focus()
