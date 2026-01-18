extends Node2D

signal request_open_game
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$mainCharacter2D/Camera2D.enabled = true

func safe_state() -> void:
	var player = get_tree().get_nodes_in_group("Player")[1]
	if player:
		SaveManager.save_current_game(player)	
		
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("switch"):
			$mainCharacter2D/Camera2D.enabled = false
			safe_state()
			emit_signal("request_open_game")
