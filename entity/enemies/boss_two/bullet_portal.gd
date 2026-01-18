extends Node2D
class_name BulletPortal

@onready var sprite = $AnimatedSprite2D
@onready var exit = $ShootingPoint
@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var tracking: bool = true
@onready var fixed_direction: Vector2
@onready var amount: int

var bullet = preload("res://entity/enemies/boss_test/boss_bullet.tscn")


func setup(bullet_type: String, bullet_amount: int, setup_tracking: bool, setup_direction: Vector2 = Vector2.RIGHT):
	tracking = setup_tracking
	fixed_direction = setup_direction
	amount = bullet_amount
	if bullet_type == "normal":
		bullet = preload("res://entity/enemies/boss_test/boss_bullet.tscn")
	elif bullet_type == "duo":
		bullet = preload("res://entity/enemies/boss_two/duo_bullet.tscn")
	else:
		print("Invalid Bullettype")
	
func _ready():
	sprite.play("appear")
	await sprite.animation_finished
	var direction: Vector2
	
	for n in range(amount):
		if tracking:
			direction = (player.global_position - exit.global_position).normalized()
		else:
			direction = fixed_direction.normalized()

		var b := bullet.instantiate()
		get_tree().current_scene.add_child(b)
		b.global_position = exit.global_position
		b.global_rotation = direction.angle()
		
		await get_tree().create_timer(0.1, false).timeout
	
	
	sprite.play("disappear")
	await sprite.animation_finished

	queue_free()
