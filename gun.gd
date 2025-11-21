extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

const bullet = preload("res://bullet.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(get_global_mouse_position())
	rotation_degrees = wrap(rotation_degrees,0,360)
	if rotation_degrees > 90 and rotation_degrees < 270:
		scale.y = -0.20
	else:
		scale.y = 0.20
	if rotation_degrees > 180:
		z_index = -1
	else: 
		z_index = 1
	if Input.is_action_just_pressed("shoot"):
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = %ShootingPoint.global_position
		bullet_instance.global_rotation = (get_global_mouse_position()-global_position).normalized().angle()
		%ShootingPoint.add_child(bullet_instance)
