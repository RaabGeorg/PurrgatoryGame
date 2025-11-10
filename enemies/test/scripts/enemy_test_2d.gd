extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 50
	move_and_slide()
