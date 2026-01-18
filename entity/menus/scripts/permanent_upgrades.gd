extends Control

@onready var soul_display = %DisplaySoulsValue
@onready var max_health_buy_counter = %BuyCounter

var current_data : PlayerData

func _ready() -> void:
	load_and_display()
	
func _physics_process(delta: float) -> void:
	var base_health = 5
	var upgrades_bought = current_data.max_health - base_health
	var max_upgrades = 5
	
	max_health_buy_counter.text = str(upgrades_bought) + " / " + str(max_upgrades)


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
	#soul_display.text = "Souls: " + str(current_data.souls)
	
	var base_health = 5
	var upgrades_bought = current_data.max_health - base_health
	var max_upgrades = 5
	
	max_health_buy_counter.text = str(upgrades_bought) + " / " + str(max_upgrades)

	


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
