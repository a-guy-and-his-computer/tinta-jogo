extends CharacterBody2D

@export var VELOCIDADE = 100.0
@export var ACELERACAO = 200.0
@export var FRICCAO = 230.0
@export var LIMITE_MAX_ESQUERDA = 50.0
@export var LIMITE_MAX_DIREITA = 50.0

@onready var LIMITE_ESQUERDA: CollisionShape2D = $"../CameraLimite/LimiteEsquerda"
@onready var LIMITE_DIREITA: CollisionShape2D = $"../CameraLimite/LimiteDireita"

func _ready() -> void:
	LIMITE_ESQUERDA.position.x = -1. * LIMITE_MAX_ESQUERDA
	LIMITE_DIREITA.position.x = LIMITE_MAX_DIREITA

func _physics_process(delta: float) -> void:
	var direcao := Input.get_axis("esquerda", "direita")
	
	if direcao != 0:
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE, ACELERACAO * delta)
	
	else:
		velocity.x = move_toward(velocity.x, 0, FRICCAO)

	move_and_slide()
