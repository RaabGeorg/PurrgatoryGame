extends State
class_name PortalAttack3

@export var boss: CharacterBody2D
var player: CharacterBody2D

var num: int = 36
var radius: float = 100.0
const portal = preload("res://entity/enemies/boss_two/bullet_portal.tscn")

func spawnPortal(pos: Vector2):
	var portal := portal.instantiate()
	get_tree().current_scene.add_child(portal)
	portal.setup("normal", 1, true)
	portal.global_position = pos

func Enter():
	player = get_tree().get_first_node_in_group("Player")
	var players_pos = player.global_position	
	
	for i in range(num):
		if i % (num / 4) == 0:
			await get_tree().create_timer(0.5, false).timeout
		var angle = TAU / num * i
		var spawn_pos = players_pos + Vector2(cos(angle), sin(angle)) * radius
		spawnPortal(spawn_pos)

	print("TRANSITIONING")
	Transitioned.emit(self, "BasicAttack")

func Exit():
	%SpecialAttackCD.start()
