extends State
class_name CrazyShot

@export var boss: CharacterBody2D
const bullet = preload("res://entity/enemies/boss_two/duo_bullet.tscn")
const bullet2 = preload("res://entity/enemies/boss_test/boss_bullet.tscn")

@onready var offset = 0.05

func circleFuck():
	for n in range(160):
		for m in range(2):
			var b := bullet.instantiate()
			get_tree().current_scene.add_child(b)
			b.global_position = %ShootingPoint.global_position
			match m:
				0:
					b.global_rotation = PI - offset
				1:
					b.global_rotation = TAU - offset
					
		offset += 0.04
		await get_tree().create_timer(0.05, false).timeout

func spawn_ring(angle_offset: float, count: int):
	for m in range(count):
		
		var b := bullet2.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = %ShootingPoint.global_position
		b.global_rotation = TAU / count * m + angle_offset

func Enter():
	circleFuck()
	await get_tree().create_timer(2, false).timeout
	for n in range(8):
		spawn_ring(PI / 6, 12)
		await get_tree().create_timer(randf() * 3, false).timeout
		
	print("TRANSITIONING")
	Transitioned.emit(self, "BasicAttack2")
		
func Exit():
	%SpecialAttackCD.start()
	
