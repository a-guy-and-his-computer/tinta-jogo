extends Area2D

var speed = 100
var direction = 1
var posicao_inicial = 0.0
@export var distancia = 50.0 

func _ready() -> void:
	posicao_inicial = position.x

func _process(delta: float) -> void:
	position.x += speed * delta * direction

	if position.x >= posicao_inicial + distancia:
		direction = -1
	elif position.x <= posicao_inicial - distancia:
		direction = 1

func _on_obstaculo_hor_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.global_position = body.ULTIMO_CHECKPOINT
