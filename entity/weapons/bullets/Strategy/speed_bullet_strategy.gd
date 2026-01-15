class_name SpeedBulletStrategy
extends BaseBulletStrategy


@export var speed_increase = 50

func _init():
	upgrade_text = "speed"
	
func apply_upgrade(Bullet: bullet,weapon):
	Bullet.SPEED += speed_increase
