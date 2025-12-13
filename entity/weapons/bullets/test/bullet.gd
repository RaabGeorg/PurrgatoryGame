extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

const SPEED: int = 300

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta



func _on_hit_box_area_entered(area: Area2D) -> void:
	queue_free()
