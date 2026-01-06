extends CharacterBody2D

signal enemy_died

@onready var player = get_tree().get_nodes_in_group("Player")[0]
@onready var sprite = $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var shoot_timer = $Timer

@export var bullet_scene: PackedScene
@export var speed: float = 40.0              
@export var stop_distance: float = 70.0
@export var knockback_force: float = 50.0    
@export var knockback_time: float = 0.3    

var _is_knockback: bool = false
var _knockback_timer: float = 0.0

func _ready() -> void:
	shoot_timer.timeout.connect(_on_shoot_timer_timeout)
	shoot_timer.start()
	%AnimatedSprite2D.modulate = Color(0.557, 0.572, 0.988)

func _physics_process(delta: float) -> void:
	if _is_knockback:
		_knockback_timer -= delta
		if _knockback_timer <= 0.0:
			_is_knockback = false
			velocity = Vector2.ZERO
		move_and_slide()
		return

	var distance_to_player = global_position.distance_to(player.global_position)
	var direction = global_position.direction_to(player.global_position)

	if distance_to_player > stop_distance:
		velocity = direction * speed
		sprite.play("running")
	else:
		velocity = Vector2.ZERO
		sprite.play("idle")

	move_and_slide()

	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

func _on_shoot_timer_timeout() -> void:
	if player and not _is_knockback and velocity == Vector2.ZERO:
		shoot()

func shoot() -> void:
	if bullet_scene:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = muzzle.global_position
		var dir = global_position.direction_to(player.global_position)
		if bullet.has_method("setup"):
			bullet.setup(dir)

func _on_health_health_depleted() -> void:
	enemy_died.emit()
	get_tree().call_group("Player", "dropped_gold", 40)
	queue_free()

func apply_knockback(from_position: Vector2) -> void:
	var away = (global_position - from_position).normalized()
	velocity = away * knockback_force
	_is_knockback = true
	_knockback_timer = knockback_time
