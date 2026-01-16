extends Control

@onready var soul_display = %DisplaySoulsValue

var current_data : PlayerData

func _ready() -> void:
	load_and_display()

func load_and_display() -> void:
	var path = SaveManager._get_path(SaveManager.current_slot)
	
	if FileAccess.file_exists(path):
		current_data = ResourceLoader.load(path) as PlayerData
	
	if not current_data:
		current_data = PlayerData.new()
		current_data.max_health = 5
		current_data.souls = 0
		
	update_ui_text()

func update_ui_text() -> void:
	soul_display.text = "Souls: " + str(current_data.souls)


func _on_permanent_2_pressed() -> void:
	var cost = 20
	var health_limit = 10
	
	if current_data.max_health >= health_limit:
		print("Maximum health reached")
		return
	
	if current_data.souls >= cost:
		current_data.souls -= cost
		current_data.max_health += 1
		
		var path = SaveManager._get_path(SaveManager.current_slot)
		ResourceSaver.save(current_data, path)
		
		update_ui_text()
		print("Max Health Upgraded!")
	else:
		print("Not enough souls!")


func _on_start_run_pressed() -> void:
	pass # Replace with function body.
	var load_screen = load("res://entity/menus/loading_screen.tscn").instantiate()
	load_screen.target_scene_path = "res://root.tscn"
	get_tree().root.add_child(load_screen)
	self.queue_free()
