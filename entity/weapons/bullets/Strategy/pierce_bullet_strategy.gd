class_name PiercingBulletStrategy
extends BaseBulletStrategy


func _init():
	upgrade_text = "pierce"
	price = 1000
	
func apply_upgrade(Bullet: bullet,weapon):
	Bullet.max_pierce += 1
