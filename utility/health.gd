class_name Health
extends Node


signal max_health_changed(diff: int)
signal health_changed(diff: int)
signal health_depleted


@export var max_health: int = 5 : set = set_max_health, get = get_max_health
@export var immortality: bool = false : set = set_immortality, get = get_immortality

var immortality_timer: Timer = null

@onready var health: int = max_health : set = set_health, get = get_health


func set_max_health(value: int):
	var clamped_value = 1 if value <= 0 else value
	
	if not clamped_value == max_health:
		var difference = clamped_value - max_health
		max_health = value
		max_health_changed.emit(difference)
		
		if health > max_health:
			health = max_health


func get_max_health() -> int:
	return max_health



func set_immortality(state: bool) -> void:
	immortality = state
	if not is_instance_valid(%AnimatedSprite2D):
		return
	if state:
		%AnimatedSprite2D.modulate = Color(1, 1, 1, 0.5) # halb transparent
	else:
		%AnimatedSprite2D.modulate = Color(1, 1, 1, 1)   # normal


func get_immortality() -> bool:
	return immortality


func set_temporary_immortality(time: float) -> void:
	immortality = true
	var t: SceneTreeTimer = get_tree().create_timer(time, false) 
	t.timeout.connect(func():
		set_immortality(false)
	)

func set_health(value: int):
	if value < health and immortality:
		return
	
	var clamped_value = clampi(value, 0, max_health)
	if clamped_value != health:
		var difference = clamped_value - health
		health = value
		health_changed.emit(difference)
		
		if health <= 0:
			health_depleted.emit()


func get_health():
	return health   
