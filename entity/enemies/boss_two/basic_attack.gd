extends State
class_name BasicAttack

@export var boss: CharacterBody2D
var player: CharacterBody2D

const bullet = preload("res://entity/enemies/boss_test/boss_bullet.tscn")

func spawn_ring(angle_offset: float, count: int):
	for m in range(count):
		var b := bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = %ShootingPoint.global_position
		b.global_rotation = TAU / count * m + angle_offset

func Enter():
	for n in randi_range(1, 4):
		await get_tree().create_timer(0.5, false).timeout
		spawn_ring(PI/randi_range(1, 100), randi_range(3, 24))
	
	await get_tree().create_timer(randi_range(0.5, 1.5), false).timeout
	
	Transitioned.emit(self, "BasicAttack2")
