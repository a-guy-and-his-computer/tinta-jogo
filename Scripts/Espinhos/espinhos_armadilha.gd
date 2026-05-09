extends Area2D

@export var distancia : float = 17.0
@export var duracao : float = 0.41667
@export var espera_encima : float = 0.0
@export var espera_embaixo : float = 1.0

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var posicao_inicial_collision : Vector2

func _ready() -> void:
	posicao_inicial_collision = collision.position
	sprite.stop()
	_animar()

func _animar() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(collision, "position", posicao_inicial_collision + Vector2(0, distancia), duracao).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(sprite.play)
	tween.tween_interval(espera_embaixo)
	tween.tween_property(collision, "position", posicao_inicial_collision, duracao).set_ease(Tween.EASE_IN_OUT)
	tween.tween_interval(espera_encima)


func _on_espinhos_armadilha_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().quit()
