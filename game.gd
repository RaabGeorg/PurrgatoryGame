extends Node2D

@onready var path_follow = get_node("mainCharacter2D/Path2D/PathFollow2D")

func _ready() -> void:
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()

func spawn_mob():
	path_follow.progress_ratio = randf()
	var new_mob = preload("res://enemies/test/scenes/enemy_test_2d.tscn").instantiate()
	new_mob.global_position = path_follow.global_position
	add_child(new_mob)


func _on_timer_timeout():
	spawn_mob()
