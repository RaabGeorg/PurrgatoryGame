extends State
class_name ShootingPlayer

@export var boss: CharacterBody2D
const bullet = preload("res://entity/enemies/boss_test/boss_bullet.tscn")

func shoot():
	await get_tree().create_timer(1).timeout
	for n in range(0, 15):
		if n % 6 < 3:
			for m in range(0, 12):
				var bullet_instance = bullet.instantiate()
				bullet_instance.global_position = %ShootingPoint.global_position
				bullet_instance.global_rotation = (PI / 6 * m + n)
				%ShootingPoint.add_child(bullet_instance)
				print(%ShootingPoint.global_position)
		else:
			for m in range(0, 12):
				var bullet_instance = bullet.instantiate()
				bullet_instance.global_position = %ShootingPoint.global_position
				bullet_instance.global_rotation = (PI / 12 + PI / 6 * m + n)
				%ShootingPoint.add_child(bullet_instance)
		await get_tree().create_timer(0.2).timeout
	Transitioned.emit(self, "BossWander")

func Enter():
	boss.velocity = Vector2.ZERO
	shoot()
