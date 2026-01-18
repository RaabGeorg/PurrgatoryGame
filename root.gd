extends Node2D

@onready var container := $SceneContainer
var game_scene: Node
var shop_scene: Node
var first = true 
func _ready() -> void:
	game_scene = load("res://stages/game.tscn").instantiate()
	container.add_child(game_scene)
	load_game()
	
func load_game():
	get_tree().paused = false
	game_scene.visible = true
	if first != true:
			game_scene.open_game()
	else:
		first = false
	game_scene.request_open_shop.connect(open_shop)
	
func open_shop():
	game_scene.visible = false
	get_tree().paused = true
	shop_scene = load("res://stages/shop_background.tscn").instantiate()
	container.add_child(shop_scene)
	shop_scene.visible = true
	shop_scene.request_open_game.connect(close_shop)
	
func close_shop():
	shop_scene.queue_free()
	shop_scene = null
	get_tree().paused = false
	load_game()
	
