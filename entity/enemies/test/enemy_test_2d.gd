extends CharacterBody2D

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $AnimatedSprite2D


@export var speed: float = 40.0              
@export var knockback_force: float = 50.0    
@export var knockback_time: float = 0.3    

var _is_knockback: bool = false
var _knockback_timer: float = 0.0

func _physics_process(delta: float) -> void:
	if _is_knockback:
		_knockback_timer -= delta
		if _knockback_timer <= 0.0:
			_is_knockback = false
			velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	sprite.play("running")
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _on_health_health_depleted() -> void:
	get_tree().call_group("Player", "dropped_gold", 40, 1)
	queue_free()

func apply_knockback(from_position: Vector2) -> void:
	var away = (global_position - from_position).normalized()
	velocity = away * knockback_force
	_is_knockback = true
	_knockback_timer = knockback_time
