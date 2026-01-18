class_name SpeedBulletStrategy
extends BaseBulletStrategy


@export var speed_increase = 75

func _init():
	upgrade_text = "speed"
	price = 250
	
func apply_upgrade(Bullet: bullet,weapon):
	Bullet.SPEED += speed_increase
