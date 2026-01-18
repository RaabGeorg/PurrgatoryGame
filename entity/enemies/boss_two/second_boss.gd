extends CharacterBody2D
class_name SecondBoss


func _physics_process(delta: float) -> void:
	move_and_slide()
	

func _on_health_health_depleted() -> void:
	get_tree().call_group("Player", "dropped_gold", 666, 66)
	get_tree().call_group("game", "start_timer")
	queue_free()
