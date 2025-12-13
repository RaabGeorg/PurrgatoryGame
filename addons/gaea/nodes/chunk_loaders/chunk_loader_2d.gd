@icon("../../assets/chunk_loader.svg")
class_name ChunkLoader2D
extends Node

@export var generator: GaeaGenerator
@export var actor: Node2D
@export var chunk_size: Vector2i = Vector2i(16, 16)
@export var loading_radius: Vector2i = Vector2i(2, 2)
@export_group("Advanced")
@export_range(50, 500, 50, "suffix:ms") var update_rate: int = 100
@export var movement_threshold: float = 16.0
@export var load_on_ready: bool = true
@export var unload_chunks: bool = true
@export var load_closest_chunks_first: bool = true
@export var chunks_per_frame: int = 2 # NEU: wie viele Chunks pro Frame geladen werden

var _last_run: int = 0
var _last_position: Vector2i
var _last_global_position: Vector2
var _loaded_chunks: Array[Vector2] = []
var _cached_chunks: Array[Vector2] = []
var _cached_center: Vector2i
var _chunk_queue: Array[Vector2] = []

func _ready() -> void:
	generator.request_reset()
	if load_on_ready:
		_update_loading(actor.global_position)

func _process(_delta: float) -> void:
	var current_time = Time.get_ticks_msec()
	if current_time - _last_run > update_rate:
		_try_loading()
		_last_run = current_time

	# Verarbeite Queue
	_process_chunk_queue()

func _try_loading() -> void:
	var actor_position: Vector2i = _get_actor_position()
	var global_position: Vector2 = actor.global_position if is_instance_valid(actor) else Vector2.ZERO

	if actor_position == _last_position:
		return

	if _last_global_position != Vector2.ZERO:
		var distance_moved = global_position.distance_to(_last_global_position)
		if distance_moved < movement_threshold:
			return

	_last_position = actor_position
	_last_global_position = global_position
	_update_loading(actor_position)

func _update_loading(actor_position: Vector2i) -> void:
	var required_chunks: Array[Vector2] = _get_required_chunks(actor_position)

	if unload_chunks:
		for chunk in _loaded_chunks:
			if not required_chunks.has(chunk):
				generator.request_area_erasure(AABB(
					Vector3(chunk.x * chunk_size.x, chunk.y * chunk_size.y, 0),
					Vector3i(chunk_size.x, chunk_size.y, 1)
				))
				_loaded_chunks.erase(chunk)

	for required in required_chunks:
		if not _loaded_chunks.has(required) and not _chunk_queue.has(required):
			_chunk_queue.append(required)

func _process_chunk_queue() -> void:
	var count = 0
	while count < chunks_per_frame and not _chunk_queue.is_empty():
		var chunk = _chunk_queue.pop_front()
		_loaded_chunks.append(chunk)
		generator.generate_area(AABB(
			Vector3(chunk.x * chunk_size.x, chunk.y * chunk_size.y, 0),
			Vector3i(chunk_size.x, chunk_size.y, 1)
		))
		count += 1

func _get_actor_position() -> Vector2i:
	var actor_position := Vector2.ZERO
	if is_instance_valid(actor):
		actor_position = actor.global_position

	var map_position := generator.global_to_map(Vector3(actor_position.x, actor_position.y, 0.0))
	return Vector2i(floori(float(map_position.x) / chunk_size.x), floori(float(map_position.y) / chunk_size.y))

func _get_required_chunks(actor_position: Vector2i) -> Array[Vector2]:
	if actor_position == _cached_center and not _cached_chunks.is_empty():
		return _cached_chunks.duplicate()

	var chunks: Array[Vector2] = []
	for x in range(-loading_radius.x, loading_radius.x + 1):
		for y in range(-loading_radius.y, loading_radius.y + 1):
			chunks.append(Vector2(actor_position.x + x, actor_position.y + y))

	if load_closest_chunks_first:
		chunks.sort_custom(_chunk_sort.bind(actor_position))

	_cached_center = actor_position
	_cached_chunks = chunks.duplicate()
	return chunks

func _chunk_sort(chunk1: Vector2, chunk2: Vector2, center: Vector2i) -> bool:
	return chunk1.distance_squared_to(center) < chunk2.distance_squared_to(center)
