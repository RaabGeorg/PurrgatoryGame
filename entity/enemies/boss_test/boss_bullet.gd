extends Node2D

func _ready() -> void:
	pass

const SPEED: int = 45

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta

func _on_hit_box_area_entered(area: Area2D) -> void:
	queue_free()
