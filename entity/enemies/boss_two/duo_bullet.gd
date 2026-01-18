extends Node2D

func _notification(what):
	if what == NOTIFICATION_PAUSED:
		visible = false
	elif what == NOTIFICATION_UNPAUSED:
		visible = true

func _ready() -> void:
	await get_tree().create_timer(15, false).timeout
	queue_free()

const SPEED: int = 60

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
