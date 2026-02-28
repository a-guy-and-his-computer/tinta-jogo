extends CharacterBody2D

@export var VELOCIDADE = 100.0
@export var ACELERACAO = 200.0
@export var FRICCAO = 230.0

func _physics_process(delta: float) -> void:
	var direcao := Input.get_axis("esquerda", "direita")
	
	if direcao != 0:
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE, ACELERACAO * delta)
	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICCAO)

	move_and_slide()
