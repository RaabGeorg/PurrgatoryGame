extends State
class_name ShootingPlayer

@export var boss: CharacterBody2D
const bullet = preload("res://entity/enemies/boss_test/boss_bullet.tscn")

func shoot():
	await get_tree().create_timer(0.75, false).timeout
	var pattern := randi() % 4
	var rings = [10, 12, 16].pick_random()
	var base_offset := randf() * TAU
	var step = [0.15, 0.25, 0.4].pick_random()

	for n in range(15):
		match pattern:
			0:
				spawn_ring(base_offset + n * step, rings)
			1:
				spawn_ring(base_offset + n * step, rings)
				spawn_ring(base_offset - n * step, rings)
			2:
				spawn_ring(base_offset + sin(n * 0.5) * PI, rings)
			3:
				if n % 3 != 0:
					spawn_ring(base_offset + n * step, rings)

		await get_tree().create_timer(0.25, false).timeout

	Transitioned.emit(self, "BossWander")
	
func spawn_ring(angle_offset: float, count: int):
	for m in range(count):
		var b := bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = %ShootingPoint.global_position
		b.global_rotation = TAU / count * m + angle_offset
func Enter():
	boss.velocity = Vector2.ZERO
	shoot()
