extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * 50
	move_and_slide()
	sprite.play("running")
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
