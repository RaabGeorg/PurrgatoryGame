class_name CooldownBulletStrategy
extends BaseBulletStrategy

var applied = false 

func _init():
	upgrade_text = "cooldown"
	
func apply_upgrade(Bullet: bullet, weapon):
	print(weapon.shoot_timer.get_wait_time())
	if weapon.shoot_timer and applied == false:
		weapon.shoot_timer.start(weapon.shoot_timer.time_left * 0.75)
		applied = true
