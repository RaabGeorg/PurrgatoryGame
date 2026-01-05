extends Node2D

var in_game: bool = true
var x = 0

@onready var path_follow = get_node("mainCharacter2D/Path2D/PathFollow2D")

signal request_open_shop

func _ready() -> void:
	$mainCharacter2D/Camera2D.enabled = true
	boss_spawn_test()
func spawn_mob():
	path_follow.progress_ratio = randf()
	var new_mob = preload("res://entity/enemies/test/enemy_test_2d.tscn").instantiate()
	new_mob.global_position = path_follow.global_position
	add_child(new_mob)

func boss_spawn_test():
	var new_mob = preload("res://entity/enemies/boss_test/boss_Test.tscn").instantiate()
	new_mob.global_position = path_follow.global_position

	add_child(new_mob)

func _on_timer_timeout():
	spawn_mob()
	x += 1
	if x % 20 == 0:
		boss_spawn_test()
	
func _process(delta: float) -> void:
	$mainCharacter2D/Camera2D.enabled = true
	if Input.is_action_just_pressed("switch"):
			$mainCharacter2D/Camera2D.enabled = false
			emit_signal("request_open_shop")
			
