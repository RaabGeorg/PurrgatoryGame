extends Node2D

var in_game: bool = true
var x = 2
var spawn_count = 1
var wait_time = 0.75 
var boss_spawn_decision = 0

@onready var Canvas = get_node("mainCharacter2D/CanvasLayer")
@onready var path_follow = get_node("mainCharacter2D/Path2D/PathFollow2D")
@onready var arena = preload("res://stages/boss_arena.tscn").instantiate()
signal request_open_shop

func _ready() -> void:
	Canvas.visible = true
	$mainCharacter2D/Camera2D.enabled = true
	
	
func spawn_mob():
	path_follow.progress_ratio = randf()
	var new_mob = preload("res://entity/enemies/test/enemy_test_2d.tscn").instantiate()
	new_mob.global_position = path_follow.global_position
	add_child(new_mob)
	
func spawn_mob_ranged():
	path_follow.progress_ratio = randf()
	var new_mob = preload("res://entity/enemies/test/enemy_test_2d_ranged.tscn").instantiate()
	new_mob.global_position = path_follow.global_position
	add_child(new_mob)

func boss_spawn_test(choice: int):
	for n in get_tree().get_nodes_in_group("enemy"):
		n.queue_free()
	
	%BossText.show()
	await get_tree().create_timer(6, false).timeout
	%BossText.hide()
	
	arena.global_position = %mainCharacter2D.global_position
	add_child(arena)

	match choice:
		0:
			var new_mob = preload("res://entity/enemies/boss_test/boss_Test.tscn").instantiate()
			new_mob.global_position = %mainCharacter2D.global_position + Vector2(0, -115)
			add_child(new_mob)
		1:
			var new_mob = preload("res://entity/enemies/boss_two/secondBoss.tscn").instantiate()
			new_mob.global_position = %mainCharacter2D.global_position + Vector2(0, -115)
			add_child(new_mob)


func _on_timer_timeout():
	
	for i in range(spawn_count):
		spawn_mob()
		if i % 4 == 0:
			spawn_mob_ranged()
	x += 1
	
	if x % 10 == 0:
		spawn_count += 1
		
	if x % 10 == 0:
		
		%WaveTimer.stop()
		boss_spawn_test(boss_spawn_decision % 2)
		boss_spawn_decision += 1
		
		
func safe_state() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		SaveManager.save_current_game(player)

func load_state() -> void:
	var player = get_tree().get_first_node_in_group("Player")
	if player:
		SaveManager.load_from_slot(1,player)
		print(player.Gold)
		
func open_game():
	load_state()
	Canvas.visible = true
	$mainCharacter2D/Camera2D.enabled = true

func start_timer():
	arena.queue_free()
	arena = preload("res://stages/boss_arena.tscn").instantiate()
	%WaveTimer.start()
	
func _process(delta: float) -> void:
	Canvas.visible = true
	$mainCharacter2D/Camera2D.enabled = true
	if Input.is_action_just_pressed("switch"):
			safe_state()
			Canvas.visible = false
			$mainCharacter2D/Camera2D.enabled = false
			emit_signal("request_open_shop")
			
