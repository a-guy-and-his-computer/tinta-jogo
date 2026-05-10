extends VBoxContainer
@export var fullscreen_check: CheckBox
func _ready():
	load_current_settings()
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
func load_current_settings():
	var mode = DisplayServer.window_get_mode()
	fullscreen_check.button_pressed = mode == DisplayServer.WINDOW_MODE_FULLSCREEN
func _on_fullscreen_toggled(enabled: bool):
	if enabled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
