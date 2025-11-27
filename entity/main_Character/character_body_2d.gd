extends CharacterBody2D
@onready var sprite = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * 80
	move_and_slide()
	if direction == Vector2.ZERO:
		sprite.play("idle")
	#else:
		#sprite.play("walking")
		
func _process(delta: float) -> void:
	var mousePosition = get_global_mouse_position().x 
	if mousePosition < global_position.x:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
