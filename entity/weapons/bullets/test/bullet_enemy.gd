extends Node2D

const SPEED: int = 100
var velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	await get_tree().create_timer(15, false).timeout
	queue_free()

func setup(dir: Vector2) -> void:
	# This receives the direction from the enemy
	velocity = dir * SPEED
	rotation = dir.angle()

func _process(delta: float) -> void:
	# This applies the movement every frame
	position += velocity * delta

func _on_hit_box_area_entered(area: Area2D) -> void:
	queue_free()
