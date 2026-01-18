extends CharacterBody2D
class_name Player
@onready var sprite = $AnimatedSprite2D
@onready var Array_ray : Array[RayCast2D] = [%RayCast2D, %RayCast2D2, %RayCast2D3] 

@export var tilemap: TileMapLayer

var upgrades : Array[BaseBulletStrategy] = []


@onready var health = %Health

@export var Souls: int = 0:
	set(value):
		Souls = value
		if %DisplaySoulsValue:
			%DisplaySoulsValue.text = "Souls: " + str(Souls)

@export var Gold: int = 0:
	set(value):
		Gold = value
		if %DisplayGoldValue:
			%DisplayGoldValue.text = "Gold: " + str(Gold)
			
func _ready() -> void:
	%DisplayGoldValue.text = "Gold: " + str(Gold)
	%DisplayHealthValue.text = "Health: " + str(health.get_health())
	%DisplaySoulsValue.text = "Souls: " + str(Souls)
	
	if health:
		health.health_changed.connect(_on_health_changed)
		health.max_health_changed.connect(_on_max_health_changed)
	
	if SaveManager.does_save_exist(SaveManager.current_slot):
		print("save for slot", SaveManager.current_slot, "found")
		SaveManager.load_from_slot(SaveManager.current_slot, self)
	else:
		print("no save found starting new one in slot")
		SaveManager.save_current_game(self)
	if get_tree().paused == false:
		Gold = 0
		upgrades = []

func _on_health_changed(_diff: int) -> void:
	%DisplayHealthValue.text = "Health: " + str(health.get_health())
	
func _on_max_health_changed(_diff: int) -> void:
	%DisplayHealthValue.text = "Health: " + str(health.get_health())


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 62
	move_and_slide()
	if direction == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("running")
	if get_tree().paused != true:
		var local_pos = tilemap.to_local(global_position)
		var cell = tilemap.local_to_map(local_pos)
		var data = tilemap.get_cell_tile_data(cell)
		var in_lava = data != null and data.get_custom_data("hazard") == true
		if in_lava:
			if health.immortality == false:
				health.health -= 1
				health.set_temporary_immortality(0.75)
		
func _process(delta: float) -> void:
	var mousePosition = get_global_mouse_position().x 
	if mousePosition < global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	if get_tree().paused:
		for ray in Array_ray:
			if ray.is_colliding():
				if Gold >= ray.price:
					Gold -= ray.price
					upgrades.append(ray.bullet_strategy)
					print(Gold)
					%DisplayGoldValue.text = "Gold: " + str(Gold)
					Array_ray.erase(ray)
					ray.queue_free()
					

func _on_health_health_depleted() -> void:
	set_physics_process(false)
	print("death")
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		SaveManager.save_current_game(player)
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://entity/menus/death_screen.tscn")

func dropped_gold(gold : int, souls : int) -> void:
	Souls+=souls
	Gold+=gold
	print(Gold)
	print(Souls)
	
func get_save_data() -> PlayerData:
	var data = PlayerData.new()
	data.gold = Gold
	#data.health = health.get_health()
	data.max_health = health.get_max_health()
	data.souls = Souls
	#data.player_position = global_position
	data.saved_uprades = upgrades.duplicate()
	print("savdata created")
	return data
	
func load_save_data(data: PlayerData):
	if data == null: return
	Gold = data.gold
	Souls = data.souls
	
	if health:
		health.set_max_health(data.max_health)
		health.set_health(data.max_health)
	upgrades = data.saved_uprades
