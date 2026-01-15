extends Node2D
class_name small_weapons

@onready var shoot_timer: Timer = %ShootCooldown

func _ready() -> void:
	pass

const bullet = preload("res://entity/weapons/bullets/test/bullet.tscn")
var can_shoot := true

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
	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = %ShootingPoint.global_position
		bullet_instance.global_rotation = (get_global_mouse_position()-global_position).normalized().angle()
		%ShootingPoint.add_child(bullet_instance)
		%ShootCooldown.start()
		for strategy in get_parent().upgrades:
			print(strategy)
			strategy.apply_upgrade(bullet_instance,self)
			print(bullet_instance.SPEED)
		


func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
