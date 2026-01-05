extends State
class_name ChargePlayer

@export var boss: CharacterBody2D
@export var move_speed := 225.0

var player: CharacterBody2D

var move_direction : Vector2

func charge():
	move_direction = (player.global_position - boss.global_position).normalized()
	%Indicator.look_at(player.global_position)
	%Indicator.show()
	await get_tree().create_timer(0.55).timeout
	%Indicator.hide()
	boss.velocity = move_direction * move_speed
	await get_tree().create_timer(0.75).timeout
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	boss.velocity = Vector2.ZERO
	await charge()
	Transitioned.emit(self, "BossWander")
