extends Node

const SAVE_DIR = "user://saves/"
var current_slot: int = 1 

func _ready() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)

# --- SAVE ---

func save_current_game(player: Player):
	save_to_slot(current_slot, player)

func save_to_slot(slot: int, player: Player):
	current_slot = slot
	var data = player.get_save_data()
	var path = _get_path(slot)
	
	var error = ResourceSaver.save(data, path)
	if error == OK:
		print("Successfully saved to: ", path)
	else:
		print("Save failed! Error code: ", error)

# --- LOAD ---

func load_from_slot(slot: int, player: Player) -> bool:
	current_slot = slot
	var path = _get_path(slot)
	
	if not FileAccess.file_exists(path):
		print("No save found at: ", path)
		return false
		
	var data = ResourceLoader.load(path)
	if data:
		player.load_save_data(data) 
		print("Successfully loaded: ", path)
		return true
	
	return false

# --- UTILITY ---

func _get_path(slot: int) -> String:
	return SAVE_DIR + "slot_" + str(slot) + ".tres"

func does_save_exist(slot: int) -> bool:
	return FileAccess.file_exists(_get_path(slot))

func delete_save(slot: int):
	var path = _get_path(slot)
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
