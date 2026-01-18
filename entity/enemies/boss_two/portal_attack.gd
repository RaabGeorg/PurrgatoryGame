extends State
class_name PortalAttack

@export var boss: CharacterBody2D
const portal = preload("res://entity/enemies/boss_two/bullet_portal.tscn")

func spawnPortal(relativeX: float, relativeY: float):
	var portal := portal.instantiate()
	get_tree().current_scene.add_child(portal)
	portal.setup("duo", 3, true)
	portal.global_position = %ShootingPoint.global_position + Vector2(relativeX, relativeY)

func move(up: bool):
	var x: int
	var vec: Vector2
	
	if up:
		x = -1
		vec = Vector2.UP
	else:
		x = 2
		vec = Vector2.DOWN
		
	%Indicator.rotate(x * PI * 0.5)
	%Indicator.show()
	await get_tree().create_timer(0.5, false).timeout
	boss.velocity = vec * 220
	await get_tree().create_timer(0.5, false).timeout
	boss.velocity = Vector2.ZERO
	%Indicator.hide()

func Enter():
	await move(true)
	
	for n in range(5):
		await get_tree().create_timer(0.5, false).timeout
		spawnPortal(-200 + 100 * n, 25)
		
	await move(false)
	
	Transitioned.emit(self, "PortalAttack2")
