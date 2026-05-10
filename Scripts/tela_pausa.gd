extends CanvasLayer

@export var settings_button: Button

func _ready() -> void:
	visible = false
	get_tree().paused = false
	settings_button.pressed.connect(_on_settings_pressed)
	
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pausar"):
		if get_tree().paused:
			visible = false
			get_tree().paused = false
		else:
			visible = true
			get_tree().paused = true
			
			
func _on_button_pressed() -> void:
	visible = false
	get_tree().paused = false
	
	
func _on_button_2_pressed() -> void:
	get_tree().quit()
	
	
func _on_settings_pressed():
	visible = false
	set_process_input(false)
	var config = load("res://Scenes/configuracoes.tscn").instantiate()
	get_tree().current_scene.add_child(config)
	
