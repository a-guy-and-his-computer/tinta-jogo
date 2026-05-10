extends CanvasLayer

@export var menu: VBoxContainer
@export var video_settings: VBoxContainer
@export var volume_settings: VBoxContainer
@export var controls_settings: VBoxContainer
@export var back_button: Button

@export var video_button: Button
@export var volume_button: Button
@export var controls_button: Button

var nav_stack: Array[Control] = []
var current_panel

func _ready():
	
	video_settings.visible = false
	volume_settings.visible = false
	controls_settings.visible = false
	
	current_panel = menu
	_show_panel(menu)
	_update_back_button()

	back_button.pressed.connect(_on_back_pressed)
	video_button.pressed.connect(_navigate_to.bind(video_settings))
	volume_button.pressed.connect(_navigate_to.bind(volume_settings))
	controls_button.pressed.connect(_navigate_to.bind(controls_settings))
	
	if GameState.abrir_aba == "controles":
		GameState.abrir_aba = ""
		_navigate_to(controls_settings)
	elif GameState.abrir_aba == "video":
		GameState.abrir_aba = ""
		_navigate_to(video_settings)
	elif GameState.abrir_aba == "volume":
		GameState.abrir_aba = ""
		_navigate_to(volume_settings)

func _show_panel(panel: Control):
	panel.visible = true

func _update_back_button():
	back_button.visible = nav_stack.size() > 0 or GameState.origem == "pausa"

func _navigate_to(panel: Control):
	if current_panel:
		nav_stack.append(current_panel)
		current_panel.visible = false
	current_panel = panel
	_show_panel(current_panel)
	_update_back_button()

func _on_back_pressed():
	var pausa = get_tree().root.find_child("tela_pausa", true, false)
	if pausa:
		pausa.visible = true
		pausa.set_process_input(true)
	elif GameState.origem == "menu":
		GameState.origem == ""
		get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	queue_free()
