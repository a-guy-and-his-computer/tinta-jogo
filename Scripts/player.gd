extends CharacterBody2D

enum ESTADOS {NO_AR, NO_CHAO, NA_PAREDE}
var ESTADO_PLAYER = ESTADOS.NO_AR
var PULOU_DA_PAREDE = false
var ULTIMO_CHECKPOINT = Vector2.ZERO
var PULOS_RESTANTES = 0
var PIXELS_SUBIDOS_PAREDE = 0.0
var ULTIMA_POS_Y_PAREDE = 0.0
var TEMPO_TRAVADO_PAREDE = 0.0
var LIMITE_TEMPO = 6.0

@export var LIMITE_SUBIDA_PAREDE = 150.0
@export var VELOCIDADE = 225.0
@export var VELOCIDADE_FORA_DO_CHAO = 240.0
@export var VELOCIDADE_PULO = -400.0
@export var VELOCIDADE_SUBIDA_PAREDE = -150.0
@export var ACELERACAO = 380.0
@export var ACELERACAO_FORA_DO_CHAO = 190.0
@export var FRICCAO = 330.0
@export var FRICCAO_FORA_DO_CHAO = 160.0

@onready var BUFFER_DE_PULO: ShapeCast2D = $BufferDePulo
@onready var DETECTOR_PAREDE_DIREITA: RayCast2D = $DetectorParedeDireita
@onready var DETECTOR_PAREDE_ESQUERDA: RayCast2D = $DetectorParedeEsquerda
@onready var PULO_COYOTE_TIMER: Timer = $PuloCoyoteTimer
@onready var WALL_JUMP_TIMER: Timer = $WallJumpTimer

@onready var ANIMACOES: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direcao := Input.get_axis("esquerda", "direita")
	var estava_no_chao = !is_on_floor()
	var normal_da_ultima_parede = get_wall_normal()
	var estava_na_parede_direita = !DETECTOR_PAREDE_DIREITA.is_colliding()
	var estava_na_parede_esquerda = !DETECTOR_PAREDE_ESQUERDA.is_colliding()
	var descer_devagar = false
	var na_parede = DETECTOR_PAREDE_DIREITA.is_colliding() or DETECTOR_PAREDE_ESQUERDA.is_colliding()

	match ESTADO_PLAYER:
		ESTADOS.NO_AR:
			if is_on_floor():
				ESTADO_PLAYER = ESTADOS.NO_CHAO
				PULOS_RESTANTES = 1

			elif na_parede:
				ESTADO_PLAYER = ESTADOS.NA_PAREDE
				PULOS_RESTANTES = 1
				PIXELS_SUBIDOS_PAREDE = 0.0
				TEMPO_TRAVADO_PAREDE = 0.0
				ULTIMA_POS_Y_PAREDE = global_position.y

			else:
				if PULO_COYOTE_TIMER.time_left > 0 and Input.is_action_just_pressed("pular"):
					aplicar_pulo()
					print("coyote")
					PULO_COYOTE_TIMER.stop()

				elif WALL_JUMP_TIMER.time_left > 0 and Input.is_action_just_pressed("pular"):
					aplicar_wall_jump(normal_da_ultima_parede)
					print("wall")
					WALL_JUMP_TIMER.stop()

				elif Input.is_action_just_pressed("pular") and PULOS_RESTANTES > 0:
					velocity.y = VELOCIDADE_PULO
					PULOS_RESTANTES -= 1

				aplica_pulo_ajustavel()
				aplicar_gravidade(delta, descer_devagar)
				aplicar_aceleracao_fora_do_chao(direcao, delta)
				aplicar_friccao_fora_do_chao(direcao)
				buffer_pulo()

				if not is_on_floor() and velocity.y < 0:
					ANIMACOES.play("pulando")
					ANIMACOES.flip_v = false
				elif not is_on_floor() and velocity.y > 0 or PULOS_RESTANTES == 0 :
					ANIMACOES.play("caindo")
					ANIMACOES.flip_v = false
					


		ESTADOS.NO_CHAO:
			if not is_on_floor() and not na_parede:
				ESTADO_PLAYER = ESTADOS.NO_AR

			elif not is_on_floor() and na_parede:
				ESTADO_PLAYER = ESTADOS.NA_PAREDE

			else:
				PULOU_DA_PAREDE = false
				PULOS_RESTANTES = 1
				aplicar_aceleracao(direcao, delta)
				aplicar_friccao(direcao)
				aplicar_pulo()
				aplica_pulo_ajustavel()

			
			if is_on_floor() and direcao == 0:
				ANIMACOES.play("parado")
				ANIMACOES.flip_v = false
			elif is_on_floor() and direcao < 0:
				ANIMACOES.flip_h = true
				ANIMACOES.flip_v = false
				ANIMACOES.play("andando")
			elif is_on_floor() and direcao > 0:
				ANIMACOES.flip_h = false
				ANIMACOES.flip_v = false
				ANIMACOES.play("andando")


		ESTADOS.NA_PAREDE:
			if is_on_floor():
				ESTADO_PLAYER = ESTADOS.NO_CHAO
				PIXELS_SUBIDOS_PAREDE = 0.0
				TEMPO_TRAVADO_PAREDE = 0.0

			elif not na_parede:
				ESTADO_PLAYER = ESTADOS.NO_AR

			else:
				PULOU_DA_PAREDE = false
				normal_da_ultima_parede = get_wall_normal()

				if Input.is_action_pressed("travar") and TEMPO_TRAVADO_PAREDE < LIMITE_TEMPO:
					velocity.y = 0
					velocity.x = 0
					TEMPO_TRAVADO_PAREDE += delta
					ULTIMA_POS_Y_PAREDE = global_position.y

				elif Input.is_action_pressed("subir") and PIXELS_SUBIDOS_PAREDE < LIMITE_SUBIDA_PAREDE:
					velocity.y = VELOCIDADE_SUBIDA_PAREDE
					PIXELS_SUBIDOS_PAREDE += abs(velocity.y * delta)
					aplicar_aceleracao_fora_do_chao(direcao, delta)
					aplicar_friccao_fora_do_chao(direcao)

				else:
					descer_devagar = true
					aplicar_gravidade(delta, descer_devagar)
					aplicar_aceleracao_fora_do_chao(direcao, delta)
					aplicar_friccao_fora_do_chao(direcao)
				
				aplicar_wall_jump(normal_da_ultima_parede)

			if not is_on_floor() and DETECTOR_PAREDE_DIREITA.is_colliding() and velocity.y == 0:
				ANIMACOES.play("parada na parede ")
				ANIMACOES.flip_h = false
			elif not is_on_floor() and DETECTOR_PAREDE_ESQUERDA.is_colliding() and velocity.y == 0:
				ANIMACOES.play("parada na parede ")
				ANIMACOES.flip_h = true
			elif not is_on_floor() and DETECTOR_PAREDE_DIREITA.is_colliding() and velocity.y < 0:
				ANIMACOES.play("andando parede")
				ANIMACOES.flip_h = false
				ANIMACOES.flip_v = false
			elif not is_on_floor() and DETECTOR_PAREDE_ESQUERDA.is_colliding() and velocity.y < 0:
				ANIMACOES.play("andando parede")
				ANIMACOES.flip_h = true
				ANIMACOES.flip_v = false
			elif not is_on_floor() and DETECTOR_PAREDE_DIREITA.is_colliding() and velocity.y > 0:
				ANIMACOES.play("andando parede")
				ANIMACOES.flip_h = false
				ANIMACOES.flip_v = true
			elif not is_on_floor() and DETECTOR_PAREDE_ESQUERDA.is_colliding() and velocity.y > 0:
				ANIMACOES.play("andando parede")
				ANIMACOES.flip_h = true
				ANIMACOES.flip_v = true
				
	move_and_slide()

	if (estava_no_chao == is_on_floor()) and (not is_on_floor()):
		PULO_COYOTE_TIMER.start()

	elif ((estava_na_parede_esquerda == DETECTOR_PAREDE_DIREITA.is_colliding()) and (not DETECTOR_PAREDE_DIREITA.is_colliding())) or ((estava_na_parede_direita == DETECTOR_PAREDE_ESQUERDA.is_colliding()) and (not DETECTOR_PAREDE_ESQUERDA.is_colliding())):
		WALL_JUMP_TIMER.start()


func aplicar_gravidade(delta, descer_devagar):
	if descer_devagar == true:
		velocity.y = clamp(velocity.y, -1000000, 100)
	velocity += get_gravity() * delta


func aplicar_wall_jump(normal_da_ultima_parede):
	if Input.is_action_just_pressed("pular") and PULOU_DA_PAREDE == false:
		velocity.x = normal_da_ultima_parede.x * VELOCIDADE
		velocity.y = VELOCIDADE_PULO / 2
		PULOU_DA_PAREDE = true


func aplicar_pulo():
	if Input.is_action_just_pressed("pular") and (is_on_floor() or PULO_COYOTE_TIMER.time_left > 0):
		velocity.y = VELOCIDADE_PULO


func aplica_pulo_ajustavel():
	if Input.is_action_just_released("pular") and (velocity.y < 0 and velocity.y < VELOCIDADE_PULO / 4):
		velocity.y = VELOCIDADE_PULO / 4


func buffer_pulo():
	if Input.is_action_just_pressed("pular") and BUFFER_DE_PULO.is_colliding() and velocity.y > 0:
		velocity.y = VELOCIDADE_PULO


func aplicar_aceleracao(direcao, delta):
	if direcao and is_on_floor():
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE, ACELERACAO * delta)


func aplicar_aceleracao_fora_do_chao(direcao, delta):
	if direcao and not is_on_floor():
		velocity.x = move_toward(velocity.x, direcao * VELOCIDADE_FORA_DO_CHAO, ACELERACAO_FORA_DO_CHAO * delta)


func aplicar_friccao(direcao):
	if !direcao and is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICCAO)


func aplicar_friccao_fora_do_chao(direcao):
	if PULOU_DA_PAREDE and !direcao:
		print("yipee")
	elif !direcao and not is_on_floor():
		velocity.x = move_toward(velocity.x, 0, FRICCAO_FORA_DO_CHAO)


func checkpoint_entrado(posicao: Vector2):
	ULTIMO_CHECKPOINT = posicao;


func morte():
	global_position = ULTIMO_CHECKPOINT
