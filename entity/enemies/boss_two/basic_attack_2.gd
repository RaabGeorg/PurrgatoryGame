extends State
class_name BasicAttack2

@export var boss: CharacterBody2D
var player: CharacterBody2D

var rng = RandomNumberGenerator.new()

var abilities = ["PortalAttack", "CrazyShot"]
var weights = [1, 1]

const bullet = preload("res://entity/enemies/boss_test/boss_bullet.tscn")

func spawn_ring(angle_offset: float, count: int):
	for m in range(count):
		var b := bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = %ShootingPoint.global_position
		var direction = player.global_position - %ShootingPoint.global_position
		b.global_rotation = direction.angle() + (-1 * angle_offset) * floor(count / 2) + m * angle_offset  

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	
	for n in randi_range(1, 4):
		await get_tree().create_timer(0.5, false).timeout
		spawn_ring(PI/randi_range(6, 24), randi_range(2, 7))
	
	if %SpecialAttackCD.is_stopped():
		await get_tree().create_timer(0.5, false).timeout
		Transitioned.emit(self, abilities[rng.rand_weighted(weights)])
		
	await get_tree().create_timer(0.5, false).timeout

	Transitioned.emit(self, "BasicAttack")
