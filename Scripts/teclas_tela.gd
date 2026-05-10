extends VBoxContainer
@export var direita_button: Button
@export var esquerda_button: Button
@export var pulo_button: Button
@export var subir_button: Button
@export var travar_button: Button
@export var pausar_button: Button
const ACTIONS = {
	"direita": "direita",
	"esquerda": "esquerda",
	"pulo": "pular",
	"subir": "subir",
	"travar": "travar",
	"pausar": "pausar"
}
var waiting_for_input: String = ""
func _ready():
	_update_button_labels()
	direita_button.pressed.connect(_on_rebind_button_pressed.bind("direita"))
	esquerda_button.pressed.connect(_on_rebind_button_pressed.bind("esquerda"))
	pulo_button.pressed.connect(_on_rebind_button_pressed.bind("pulo"))
	subir_button.pressed.connect(_on_rebind_button_pressed.bind("subir"))
	travar_button.pressed.connect(_on_rebind_button_pressed.bind("travar"))
	pausar_button.pressed.connect(_on_rebind_button_pressed.bind("pausar"))
func _get_button(action: String) -> Button:
	match action:
		"direita": return direita_button
		"esquerda": return esquerda_button
		"pulo": return pulo_button
		"subir": return subir_button
		"travar": return travar_button
		"pausar": return pausar_button
		_: return null
func _update_button_label(action: String):
	var action_name = ACTIONS[action]
	var events = InputMap.action_get_events(action_name)
	var label_text = "Unassigned"
	if events.size() > 0:
		var event = events[0]
		if event is InputEventKey:
			if event.keycode != 0:
				label_text = OS.get_keycode_string(event.keycode)
			elif event.physical_keycode != 0:
				label_text = OS.get_keycode_string(event.physical_keycode)
	var btn = _get_button(action)
	if btn:
		btn.text = label_text
func _update_button_labels():
	for action in ACTIONS.keys():
		_update_button_label(action)
func _on_rebind_button_pressed(action: String):
	waiting_for_input = action
	var btn = _get_button(action)
	if btn:
		btn.text = "..."
	set_process_input(true)
func _input(event):
	if waiting_for_input == "":
		return
	if event is InputEventKey and event.pressed:
		var action = waiting_for_input
		var action_name = ACTIONS[action]
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name, event)
		_update_button_label(action)
		waiting_for_input = ""
		set_process_input(false)
		get_viewport().set_input_as_handled()
