class_name DamageBulletStrategy
extends BaseBulletStrategy


func _init():
	upgrade_text = "Damage"
	price = 500
	
func apply_upgrade(Bullet: bullet,weapon):
	Bullet.hitbox.set_damage(Bullet.hitbox.get_damage() + 1)
