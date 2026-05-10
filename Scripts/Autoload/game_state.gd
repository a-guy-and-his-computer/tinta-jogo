extends Node

# --- configurações ---
var fullscreen: bool = true
var master_volume: float = 100.0
var keybinds: Dictionary = {}

# --- progresso do jogo (adicione mais conforme precisar) ---
var current_scene: String = ""

func to_dict() -> Dictionary:
	return {
		"fullscreen": fullscreen,
		"master_volume": master_volume,
		"keybinds": keybinds.duplicate(),
		"current_scene": current_scene,
	}

func from_dict(data: Dictionary) -> void:
	fullscreen = data.get("fullscreen", true)
	master_volume = data.get("master_volume", 100.0)
	keybinds = data.get("keybinds", {})
	current_scene = data.get("current_scene", "")
