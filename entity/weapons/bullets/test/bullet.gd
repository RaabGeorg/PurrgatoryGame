extends Node2D
class_name bullet
# Called when the node enters the scene tree for the first time.
@export var SPEED: int = 300
@export var max_pierce := 1

var current_pierce_count := 0

func _ready() -> void:
	await get_tree().create_timer(15, false).timeout
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta


func _on_hit_box_area_entered(area: Area2D) -> void:
	current_pierce_count += 1
	
	if current_pierce_count >= max_pierce:
		queue_free()
