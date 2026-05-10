extends VBoxContainer

@export var fullscreen_check: CheckBox

func _ready():
	await get_tree().process_frame
	load_current_settings()
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)

func load_current_settings():
	fullscreen_check.button_pressed = GameState.fullscreen

func _on_fullscreen_toggled(enabled: bool):
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	GameState.fullscreen = enabled
	SaveManeger.save_settings()
