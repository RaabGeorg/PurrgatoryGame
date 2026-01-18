extends RayCast2D

@export var upgrade_label : Label
@export var sprite : Sprite2D
@export var bullet_strategy : BaseBulletStrategy
@export var price : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = bullet_strategy.texture
	upgrade_label.text = bullet_strategy.upgrade_text + "\n" + str(price) + " Gold "
	
