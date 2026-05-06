extends Area2D

func _on_espinhos_3_hor_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.global_position = body.ULTIMO_CHECKPOINT
