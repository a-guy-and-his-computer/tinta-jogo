extends CharacterBody2D

enum Estados {NO_AR, NO_CHAO, NA_PAREDE}
var estado_player = Estados.NO_AR
var PULOU_DA_PAREDE = false

@export var VELOCIDADE = 225.0
@export var VELOCIDADE_FORA_DO_CHAO = 240.0
@export var VELOCIDADE_PULO = -400.0
@export var ACELERACAO = 380.0
@export var ACELERACAO_FORA_DO_CHAO = 190.0
@export var FRICCAO = 330.0
@export var FRICCAO_FORA_DO_CHAO = 160.0

@onready var corpo_camera: CharacterBody2D = $CorpoCamera
@onready var shape_cast_2d: ShapeCast2D = $ShapeCast2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2

@onready var pulo_coyote_timer: Timer = $PuloCoyoteTimer
@onready var wall_jump_timer: Timer = $WallJumpTimer

func _physics_process(delta: float) -> void:
	var direcao := Input.get_axis("esquerda", "direita")
	var estava_no_chao = !is_on_floor() # iniciando variável
	var normal_da_ultima_parede = get_wall_normal() # iniciando variável
	var estava_na_parede_direita = !ray_cast_2d.is_colliding() # iniciando variável
	var estava_na_parede_esquerda = !ray_cast_2d_2.is_colliding() # iniciando variável
	var descer_devagar = false # iniciando variável
	
	match estado_player:
		Estados.NO_AR:
			if is_on_floor():
				estado_player = Estados.NO_CHAO
			
			elif ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding():
				estado_player = Estados.NA_PAREDE
				
			else:
				if pulo_coyote_timer.time_left > 0 and Input.is_action_just_pressed("pular"):
					aplicar_pulo()
					print("coyote")
					pulo_coyote_timer.stop()
				
				elif wall_jump_timer.time_left > 0 and Input.is_action_just_pressed("pular"):
					aplicar_wall_jump(normal_da_ultima_parede)
					print("wall")
					wall_jump_timer.stop()
				
				aplica_pulo_ajustavel()
				aplicar_gravidade(delta, descer_devagar)
				aplicar_aceleracao_fora_do_chao(direcao, delta)
				aplicar_friccao_fora_do_chao(direcao)
				buffer_pulo()
		
		Estados.NO_CHAO:
			if not is_on_floor() and not (ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding()):
				estado_player = Estados.NO_AR
			
			elif not is_on_floor() and (ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding()):
				estado_player = Estados.NA_PAREDE
			
			else:
				PULOU_DA_PAREDE = false
				aplicar_aceleracao(direcao, delta)
				aplicar_friccao(direcao)
				aplicar_pulo()
				aplica_pulo_ajustavel()
		
		Estados.NA_PAREDE:
			if is_on_floor():
				estado_player = Estados.NO_CHAO
			
			elif not (ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding()):
				estado_player = Estados.NO_AR
			
			else:
				PULOU_DA_PAREDE = false
				descer_devagar = true
				normal_da_ultima_parede = get_wall_normal()
				aplicar_gravidade(delta, descer_devagar)
				aplicar_aceleracao_fora_do_chao(direcao, delta)
				aplicar_friccao_fora_do_chao(direcao)
				aplicar_wall_jump(normal_da_ultima_parede)

	move_and_slide() # mova o personagem
	
	if (estava_no_chao == is_on_floor()) and (not is_on_floor()):
		pulo_coyote_timer.start()
	
	elif ((estava_na_parede_esquerda == ray_cast_2d.is_colliding()) and (not ray_cast_2d.is_colliding())) or ((estava_na_parede_direita == ray_cast_2d_2.is_colliding()) and (not ray_cast_2d_2.is_colliding())):
		wall_jump_timer.start()



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
	if Input.is_action_just_pressed("pular") and (is_on_floor() or pulo_coyote_timer.time_left > 0):
		velocity.y = VELOCIDADE_PULO


func aplica_pulo_ajustavel():
	if Input.is_action_just_released("pular") and (velocity.y < 0 and velocity.y < VELOCIDADE_PULO / 4):
		velocity.y = VELOCIDADE_PULO / 4


func buffer_pulo():
	if Input.is_action_just_pressed("pular") and shape_cast_2d.is_colliding() and velocity.y > 0:
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
