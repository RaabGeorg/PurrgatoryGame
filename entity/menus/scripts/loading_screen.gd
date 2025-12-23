extends CanvasLayer

signal scene_loaded

@onready var label: Label = $Label

var scene_path: String = ""
var loading_status: int = 0
