extends CharacterBody2D


@export var VELOCIDADE = 300.0
@export var VELOCIDADE_NO_AR = 200.0
@export var VELOCIDADE_PULO = -400.0
@export var ACELERACAO = 400.0
@export var ACELERACAO_NO_AR = 400.0
@export var FRICCAO = 300.0
@export var FRICCAO_NO_AR = 200.0

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var pulo_coyote_timer: Timer = $PuloCoyoteTimer
@onready var wall_jump_timer: Timer = $WallJumpTimer

func _physics_process(delta: float) -> void:
	print(get_wall_normal())
	aplicar_gravidade(delta)
	manusear_wall_jump()
	manusear_pulo()

	var direcao := Input.get_axis("esquerda", "direita")
	aplicar_aceleracao(direcao, delta)
	aplicar_aceleracao_no_ar(direcao, delta)
	aplicar_friccao(direcao)
	aplicar_friccao_no_ar(direcao)
	
	# checar se está na parede
	# checar se está no chão

	move_and_slide() # mova o personagem
	
	# checar se saiu da parede e estava na parede antes. Se sim, começe o timer de wall jump
	
	# checar se saiu do chão e estava no chão antes. Se sim, começe o timer de coyote


func aplicar_gravidade(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta


func manusear_wall_jump():
	if Input.is_action_just_pressed("pular") and (is_on_wall() and not is_on_floor()):
		velocity.x = get_wall_normal().x * VELOCIDADE
		velocity.y = VELOCIDADE_PULO / 2


func manusear_pulo():
	if Input.is_action_just_pressed("pular") and is_on_floor():
		velocity.y = VELOCIDADE_PULO
	elif Input.is_action_just_pressed("pular") and ray_cast_2d.is_colliding():
		velocity.y = VELOCIDADE_PULO


func aplicar_aceleracao(direcao, delta):
	if direcao and is_on_floor():
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE, ACELERACAO * delta)


func aplicar_aceleracao_no_ar(direcao, delta):
	if direcao and not is_on_floor():
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE_NO_AR, ACELERACAO_NO_AR * delta)


func aplicar_friccao(direcao):
	if !direcao and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICCAO)


func aplicar_friccao_no_ar(direcao):
	if !direcao and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICCAO_NO_AR)
