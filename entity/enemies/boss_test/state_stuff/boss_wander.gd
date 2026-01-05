extends State
class_name BossWander

@export var boss: CharacterBody2D
@export var move_speed := 20.0

var player: CharacterBody2D

var move_direction : Vector2
var wander_time : float
var rng = RandomNumberGenerator.new()

var abilities = ["ChasingPlayer", "ChargePlayer", "ShootingPlayer"]
var weights = [2, 3, 5]

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	randomize_wander()
	%AbilityCD.start()
	
func Update(delta: float):
	if wander_time >  0:
		wander_time -= delta
		
	else:
		randomize_wander()
	
func Physics_Update(delta: float):
	if boss:
		boss.velocity = move_direction * move_speed
		
	if %AbilityCD.is_stopped():
		Transitioned.emit(self, abilities[rng.rand_weighted(weights)])
