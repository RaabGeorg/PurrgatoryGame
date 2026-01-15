extends State
class_name ChasingPlayer

@export var boss: CharacterBody2D
@export var min_speed := 59.0
@export var max_speed := 130.0
@export var max_distance := 400.0

var player: CharacterBody2D
var move_direction : Vector2


func chase():
	move_direction = (player.global_position - boss.global_position).normalized()
	var distance := boss.global_position.distance_to(player.global_position)
	var t = clamp(distance / max_distance, 0.0, 1.0)
	var speed = lerp(min_speed, max_speed, t)
	boss.velocity = move_direction * speed
	print(speed)
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	%ChaseCD.start()
	
func Update(delta: float):
	if %ChaseCD.is_stopped():
		Transitioned.emit(self, "BossWander")
	
func Physics_Update(delta: float):
	
	if boss:
		chase()
	print("Chase")
