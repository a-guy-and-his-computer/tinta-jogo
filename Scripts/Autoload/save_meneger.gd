extends Node

const SAVE_DIR = "user://saves/"
const SETTINGS_PATH = "user://settings.json"

func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(SAVE_DIR)
	load_settings()

# ============================================================
# PROGRESSO DO JOGO
# ============================================================

func save_game(slot: int) -> void:
	var data = GameState.to_dict()
	var json = JSON.stringify(data, "  ")
	var file = FileAccess.open(SAVE_DIR + "slot_%d.json" % slot, FileAccess.WRITE)
	if file:
		file.store_string(json)
	else:
		push_error("SaveManager: erro ao salvar slot %d" % slot)

func load_game(slot: int) -> bool:
	var path = SAVE_DIR + "slot_%d.json" % slot
	if not FileAccess.file_exists(path):
		push_warning("SaveManager: save não encontrado no slot %d" % slot)
		return false
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("SaveManager: erro ao abrir slot %d" % slot)
		return false
	var data = JSON.parse_string(file.get_as_text())
	if not data is Dictionary:
		push_error("SaveManager: JSON inválido no slot %d" % slot)
		return false
	GameState.from_dict(data)
	return true

func has_save(slot: int) -> bool:
	return FileAccess.file_exists(SAVE_DIR + "slot_%d.json" % slot)

func delete_save(slot: int) -> void:
	var path = SAVE_DIR + "slot_%d.json" % slot
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)

func save_act(slot: int) -> void:
	save_game(slot)

# ============================================================
# CONFIGURAÇÕES
# ============================================================

func save_settings() -> void:
	var data = {
		"fullscreen": GameState.fullscreen,
		"master_volume": GameState.master_volume,
		"keybinds": GameState.keybinds.duplicate()
	}
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data, "  "))
	else:
		push_error("SaveManager: erro ao salvar configurações")

func load_settings() -> void:
	if not FileAccess.file_exists(SETTINGS_PATH):
		_init_default_keybinds()
		save_settings()
		return
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	if not file:
		return
	var data = JSON.parse_string(file.get_as_text())
	if not data is Dictionary:
		return
	GameState.fullscreen = data.get("fullscreen", true)
	GameState.master_volume = data.get("master_volume", 100.0)
	GameState.keybinds = data.get("keybinds", {})
	_apply_settings()

func _init_default_keybinds() -> void:
	var actions = ["direita", "esquerda", "pular", "subir", "travar", "pausar"]
	for action_name in actions:
		if InputMap.has_action(action_name):
			var events = InputMap.action_get_events(action_name)
			if events.size() > 0 and events[0] is InputEventKey:
				GameState.keybinds[action_name] = events[0].keycode
			else:
				GameState.keybinds[action_name] = -1

func _apply_settings() -> void:
	# vídeo
	if GameState.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	# áudio
	var volume = GameState.master_volume
	var db = linear_to_db(volume / 100.0) if volume > 0 else -60.0
	var bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, clamp(db, -60.0, 0.0))
	AudioServer.set_bus_mute(bus, volume <= 0)

	# teclas
	for action_name in GameState.keybinds:
		var keycode = GameState.keybinds[action_name]
		if keycode == -1 or keycode == 0:
			continue
		var event = InputEventKey.new()
		event.keycode = keycode
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
