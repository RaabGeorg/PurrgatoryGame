class_name HurtBox
extends Area2D


signal received_damage(damage: int)


@export var health: Health


func _ready():
	connect("area_entered", _on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	if area is HitBox:
		var hitbox := area as HitBox
		if is_in_group("player_hurtbox"):
			if health.get_immortality() == false:
				health.health -= hitbox.damage
				received_damage.emit(hitbox.damage)
				health.set_temporary_immortality(0.5)
		else:
			health.health -= hitbox.damage
			received_damage.emit(hitbox.damage)
	if area.get_parent().has_method("apply_knockback"):
		area.get_parent().apply_knockback(global_position)
