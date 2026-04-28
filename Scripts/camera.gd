extends Camera2D

const SCREEN_WIDTH := 320.0
var target: Node2D
@export var follow_threshold_x: float = 0.0
@export var lerp_speed: float = 5.0
var left_limit: float = 0.0

func _ready() -> void:
	get_target()
	left_limit = floor(target.global_position.x / SCREEN_WIDTH) * SCREEN_WIDTH

func _process(delta: float) -> void:
	if not target:
		return

	var player_screen_x = target.global_position.x - global_position.x

	if target.global_position.x < left_limit:
		var target_x = target.global_position.x + follow_threshold_x
		global_position.x = lerp(global_position.x, target_x, lerp_speed * delta)
		left_limit = global_position.x - SCREEN_WIDTH * 0.5

	elif player_screen_x > follow_threshold_x:
		var target_x = target.global_position.x - follow_threshold_x
		global_position.x = lerp(global_position.x, target_x, lerp_speed * delta)
		left_limit = global_position.x - SCREEN_WIDTH * 0.5

	global_position.y = lerp(global_position.y, target.global_position.y, lerp_speed * delta)

func get_target():
	var nodes = get_tree().get_nodes_in_group("Player")
	if nodes.size() == 0:
		push_error("Player not found")
		return
	target = nodes[0]
