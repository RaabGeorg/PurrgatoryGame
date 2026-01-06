extends State
class_name ChargePlayer

@export var boss: CharacterBody2D
@export var min_speed := 130.0
@export var max_speed := 425.0
@export var max_distance := 500.0

var player: CharacterBody2D

var move_direction : Vector2

func charge():
	move_direction = (player.global_position - boss.global_position).normalized()
	var distance := boss.global_position.distance_to(player.global_position)
	var t = clamp(distance / max_distance, 0.0, 1.0)
	var speed = lerp(min_speed, max_speed, t)
	%Indicator.look_at(player.global_position)
	%Indicator.show()
	await get_tree().create_timer(0.2, false).timeout
	%Indicator.hide()
	boss.velocity = move_direction * speed
	await get_tree().create_timer(0.6, false).timeout
	print(speed)
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	boss.velocity = Vector2.ZERO
	await charge()
	Transitioned.emit(self, "BossWander")
