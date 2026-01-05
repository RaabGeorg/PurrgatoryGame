extends State
class_name ChasingPlayer

@export var boss: CharacterBody2D
@export var move_speed := 55.0

var player: CharacterBody2D
var move_direction : Vector2

func chase():
	move_direction = (player.global_position - boss.global_position).normalized()
	boss.velocity = move_direction * move_speed
	
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
