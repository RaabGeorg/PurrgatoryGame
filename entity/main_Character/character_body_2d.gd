extends CharacterBody2D
class_name Player
@onready var sprite = $AnimatedSprite2D
@export var Gold: int = 0
 
var upgrades : Array[BaseBulletStrategy] = []

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 62
	move_and_slide()
	if direction == Vector2.ZERO:
		sprite.play("idle")
	else:
		sprite.play("running")
		
func _process(delta: float) -> void:
	var mousePosition = get_global_mouse_position().x 
	if mousePosition < global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		

func _on_health_health_depleted() -> void:
	set_physics_process(false)
	print("death")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://entity/menus/death_screen.tscn")

func dropped_gold(gold : int) -> void:
	Gold+=gold
	print(Gold)
