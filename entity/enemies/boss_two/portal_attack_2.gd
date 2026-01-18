extends State
class_name PortalAttack2

@export var boss: CharacterBody2D
const portal = preload("res://entity/enemies/boss_two/bullet_portal.tscn")

func spawnPortal(relativeX: float, relativeY: float, direction: Vector2):
	var portal := portal.instantiate()
	get_tree().current_scene.add_child(portal)
	portal.setup("duo", 5, false, direction)
	portal.global_position = %ShootingPoint.global_position + Vector2(relativeX, relativeY)

func Enter():
	var direction = Vector2.RIGHT	
	for n in range(8):
		await get_tree().create_timer(0.5, false).timeout
		
		var val = pow(-1, n)  
		if val < 0:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
		
		spawnPortal(val * 235, 125 - 35 * n, direction)
		
	Transitioned.emit(self, "PortalAttack3")
