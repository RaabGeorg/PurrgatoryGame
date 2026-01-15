class_name BaseBulletStrategy
extends Resource

@export var texture : Texture2D = preload("res://assets/Arrow.png")
@export var upgrade_text : String = "Nothing"

# Called when the node enters the scene tree for the first time.
func apply_upgrade(Bullet: bullet, weapon):
	print("applíed basic")
	pass 
