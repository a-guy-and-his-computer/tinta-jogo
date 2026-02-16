extends CharacterBody2D

@export var VELOCIDADE = 150.0
@export var ACELERACAO = 800.0
@export var FRICCAO = 1000.0
@export var VELOCIDADE_PULO = -300.0
@export var VELOCIDADE_PULO_DUPLO = 0.8
const GRAVIDADE = 980
@export var MODIFICADOR_GRAVIDADE = 1
@export var ACELERACAO_NO_AR = 400
@export var RESISTENCIA_DO_AR = 200.0

@onready var pulo_coiote_timer: Timer = $PuloCoioteTimer
@onready var wall_jump_timer: Timer = $WallJumpTimer

var double_jump = false
var acabou_de_pular_da_parede = false
var normal_da_parede_anterior = Vector2.ZERO

func _physics_process(delta: float) -> void:
	aplicar_gravidade(delta)
	manusear_wall_jump()
	manusear_pulo()
	
	var direcao := Input.get_axis("ui_left", "ui_right")
	aplicar_aceleracao(direcao, delta)
	aplicar_aceleracao_no_ar(direcao, delta)
	aplicar_friccao(direcao, delta)
	aplicar_resistencia_ar(direcao, delta)
	
	var estava_na_parede = is_on_wall() and not is_on_floor()
	if estava_na_parede:
		normal_da_parede_anterior = get_wall_normal()
	
	var estava_no_chao = is_on_floor()
	move_and_slide()
	var saiu_da_borda = estava_no_chao and not is_on_floor() and velocity.y >= 0
	if saiu_da_borda:
		pulo_coiote_timer.start()
	
	acabou_de_pular_da_parede = false
	var saiu_da_parede = estava_na_parede and not (is_on_wall() and not is_on_floor())
	if saiu_da_parede:
		wall_jump_timer.start()

func aplicar_gravidade(delta: float):
	if not is_on_floor():
		velocity.y += (GRAVIDADE * MODIFICADOR_GRAVIDADE) * delta

func manusear_wall_jump():
	if not is_on_wall() and wall_jump_timer.time_left == 0:
		return
	
	var normal_da_parede = get_wall_normal()
	if wall_jump_timer.time_left > 0:
		normal_da_parede = normal_da_parede_anterior
	
	if is_on_wall() and not is_on_floor():
		if Input.is_action_just_pressed("ui_accept"):
			velocity.x = normal_da_parede.x * VELOCIDADE
			velocity.y =	 VELOCIDADE_PULO
			acabou_de_pular_da_parede = true

func manusear_pulo():
	if is_on_floor():
		double_jump = true
	
	if is_on_floor() or pulo_coiote_timer.time_left > 0.0:
		if Input.is_action_just_pressed("ui_accept"): 
			velocity.y = VELOCIDADE_PULO

	elif not is_on_floor():
		if Input.is_action_just_released("ui_accept") and velocity.y < (VELOCIDADE_PULO / 2):
			velocity.y = VELOCIDADE_PULO / 2
		
		if Input.is_action_just_pressed("ui_accept") and double_jump and not acabou_de_pular_da_parede:
			velocity.y = VELOCIDADE_PULO * VELOCIDADE_PULO_DUPLO
			double_jump = false

func aplicar_aceleracao(direcao, delta: float):
	if not is_on_floor():
		return
	if direcao:
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE, ACELERACAO * delta)

func aplicar_aceleracao_no_ar(direcao, delta: float):
	if is_on_floor():
		return
	if direcao:
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE, ACELERACAO_NO_AR * delta)

func aplicar_friccao(direcao, delta: float):
	if not direcao and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICCAO * delta)

func aplicar_resistencia_ar(direcao, delta: float):
	if not direcao and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, RESISTENCIA_DO_AR * delta)
