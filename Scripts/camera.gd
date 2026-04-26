extends Camera2D

var target: Node2D
@export var follow_threshold_x: float = 0.0  
@export var lerp_speed: float = 5.0           

func _ready() -> void:
	get_target()

func _process(delta: float) -> void:
	if not target:
		return

	var player_screen_x = target.global_position.x - global_position.x

	if player_screen_x > follow_threshold_x:
		var target_x = target.global_position.x - follow_threshold_x
		global_position.x = lerp(global_position.x, target_x, lerp_speed * delta)

	global_position.y = lerp(global_position.y, target.global_position.y, lerp_speed * delta)

func get_target():
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player not found")
		return
	target = nodes[0]
