@icon("../../assets/chunk_loader.svg")
class_name ChunkLoader2D
extends Node


@export var generator: GaeaGenerator
@export var actor: Node2D
@export var chunk_size: Vector2i = Vector2i(16, 16)
@export var loading_radius: Vector2i = Vector2i(2, 2)
@export_group("Advanced")
## Amount of miliseconds the loader waits before it checks if new chunks need to be loaded.
@export_range(50, 500, 50, "suffix:ms") var update_rate: int = 100
## Minimum movement in pixels before chunks are reloaded
@export var movement_threshold: float = 16.0
## Executes the loading process on ready [br]
## [b]Warning:[/b] No chunks might load if set to false.
@export var load_on_ready: bool = true
## If set to true, the Chunk Loader unloads chunks left behind
@export var unload_chunks: bool = true
## If set to true, will prioritize chunks closer to the [param actor].
@export var load_closest_chunks_first: bool = true

var _last_run: int = 0
var _last_position: Vector2i
var _last_global_position: Vector2
var _loaded_chunks: Array[Vector2]
var _cached_chunks: Array[Vector2] = []
var _cached_center: Vector2i


func _ready() -> void:
	generator.request_reset()
	if load_on_ready:
		_update_loading(actor.global_position)


func _process(_delta: float) -> void:
	var current_time = Time.get_ticks_msec()
	if current_time - _last_run > update_rate:
		_try_loading()
		_last_run = current_time


func _try_loading() -> void:
	var actor_position: Vector2i = _get_actor_position()
	var global_position: Vector2 = actor.global_position if is_instance_valid(actor) else Vector2.ZERO

	# Check movement threshold
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
		var chunks_to_unload: Array[Vector2] = []
		for chunk in _loaded_chunks:
			if not required_chunks.has(chunk):
				chunks_to_unload.append(chunk)
		
		# Unload chunks deferred to avoid frame drops
		if not chunks_to_unload.is_empty():
			call_deferred("_unload_chunks", chunks_to_unload)

	var chunks_to_load: Array[Vector2] = []
	for required in required_chunks:
		if not _loaded_chunks.has(required):
			chunks_to_load.append(required)
			_loaded_chunks.append(required)
	
	# Load chunks deferred
	if not chunks_to_load.is_empty():
		call_deferred("_load_chunks", chunks_to_load)


func _unload_chunks(chunks: Array[Vector2]) -> void:
	for chunk in chunks:
		_loaded_chunks.erase(chunk)
		generator.request_area_erasure(AABB(
			Vector3(chunk.x * chunk_size.x, chunk.y * chunk_size.y, 0),
			Vector3i(chunk_size.x, chunk_size.y, 1)
		))


func _load_chunks(chunks: Array[Vector2]) -> void:
	for chunk in chunks:
		generator.generate_area(AABB(
			Vector3(chunk.x * chunk_size.x, chunk.y * chunk_size.y, 0),
			Vector3i(chunk_size.x, chunk_size.y, 1)
		))


func _get_actor_position() -> Vector2i:
	var actor_position := Vector2.ZERO
	if is_instance_valid(actor):
		actor_position = actor.global_position

	var map_position := generator.global_to_map(Vector3(actor_position.x, actor_position.y, 0.0))
	var chunk_position := Vector2i(floori(float(map_position.x) / chunk_size.x), floori(float(map_position.y) / chunk_size.y))
	return chunk_position


func _get_required_chunks(actor_position: Vector2i) -> Array[Vector2]:
	# Use cache if position is the same
	if actor_position == _cached_center and not _cached_chunks.is_empty():
		return _cached_chunks.duplicate()
	
	var chunks: Array[Vector2] = []
	
	# Use pre-calculated offsets instead of range()
	for x in range(-loading_radius.x, loading_radius.x + 1):
		for y in range(-loading_radius.y, loading_radius.y + 1):
			chunks.append(Vector2(actor_position.x + x, actor_position.y + y))
	
	if load_closest_chunks_first:
		chunks.sort_custom(_chunk_sort.bind(actor_position))
	
	# Update cache
	_cached_center = actor_position
	_cached_chunks = chunks.duplicate()
	
	return chunks


func _chunk_sort(chunk1: Vector2, chunk2: Vector2, center: Vector2i) -> bool:
	return chunk1.distance_squared_to(center) < chunk2.distance_squared_to(center)
