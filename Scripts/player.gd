extends CharacterBody2D

enum ESTADOS {NO_AR, NO_CHAO, NA_PAREDE}
var ESTADO_PLAYER = ESTADOS.NO_AR
var PULOU_DA_PAREDE = false
var ULTIMO_CHECKPOINT = Vector2.ZERO

var transicao_reversa = false
var tween_atual: Tween

@export var VELOCIDADE = 225.0
@export var VELOCIDADE_FORA_DO_CHAO = 240.0
@export var VELOCIDADE_PULO = -400.0
@export var ACELERACAO = 380.0
@export var ACELERACAO_FORA_DO_CHAO = 190.0
@export var FRICCAO = 330.0
@export var FRICCAO_FORA_DO_CHAO = 160.0

@onready var BUFFER_DE_PULO: ShapeCast2D = $BufferDePulo
@onready var DETECTOR_PAREDE_DIREITA: RayCast2D = $DetectorParedeDireita
@onready var DETECTOR_PAREDE_ESQUERDA: RayCast2D = $DetectorParedeEsquerda
@onready var PULO_COYOTE_TIMER: Timer = $PuloCoyoteTimer
@onready var WALL_JUMP_TIMER: Timer = $WallJumpTimer

@onready var ZONA_DA_MORTE: Area2D = $"../ZonaDaMorte"
@onready var CHECKPOINT_1: Area2D = $"../Checkpoints/1 - Checkpoint1"
@onready var CHECKPOINT_2: Area2D = $"../Checkpoints/2 - Checkpoint2"
@onready var CHECKPOINT_3: Area2D = $"../Checkpoints/3 - Checkpoint3"

@onready var ANIMACOES: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direcao := Input.get_axis("esquerda", "direita") # Iniciando variável
	var estava_no_chao = !is_on_floor() # Iniciando variável
	var normal_da_ultima_parede = get_wall_normal() # Iniciando variável
	var estava_na_parede_direita = !DETECTOR_PAREDE_DIREITA.is_colliding() # Iniciando variável
	var estava_na_parede_esquerda = !DETECTOR_PAREDE_ESQUERDA.is_colliding() # Iniciando variável
	var descer_devagar = false # Iniciando variável
	
	match ESTADO_PLAYER:
		ESTADOS.NO_AR:
			if is_on_floor():
				ESTADO_PLAYER = ESTADOS.NO_CHAO
			
			elif DETECTOR_PAREDE_DIREITA.is_colliding() or DETECTOR_PAREDE_ESQUERDA.is_colliding():
				ESTADO_PLAYER = ESTADOS.NA_PAREDE
				
			else:
				if PULO_COYOTE_TIMER.time_left > 0 and Input.is_action_just_pressed("pular"):
					aplicar_pulo()
					print("coyote")
					PULO_COYOTE_TIMER.stop()
				
				elif WALL_JUMP_TIMER.time_left > 0 and Input.is_action_just_pressed("pular"):
					aplicar_wall_jump(normal_da_ultima_parede)
					print("wall")
					WALL_JUMP_TIMER.stop()
				
				aplica_pulo_ajustavel()
				aplicar_gravidade(delta, descer_devagar)
				aplicar_aceleracao_fora_do_chao(direcao, delta)
				aplicar_friccao_fora_do_chao(direcao)
				buffer_pulo()
				
				if not is_on_floor():
					ANIMACOES.play("pulando")
		
		
		ESTADOS.NO_CHAO:
			if not is_on_floor() and not (DETECTOR_PAREDE_DIREITA.is_colliding() or DETECTOR_PAREDE_ESQUERDA.is_colliding()):
				ESTADO_PLAYER = ESTADOS.NO_AR
			
			elif not is_on_floor() and (DETECTOR_PAREDE_DIREITA.is_colliding() or DETECTOR_PAREDE_ESQUERDA.is_colliding()):
				ESTADO_PLAYER = ESTADOS.NA_PAREDE
			
			else:
				PULOU_DA_PAREDE = false
				aplicar_aceleracao(direcao, delta)
				aplicar_friccao(direcao)
				aplicar_pulo()
				aplica_pulo_ajustavel()
			
			if is_on_floor() and direcao ==0:
				ANIMACOES.play("parado")
				
			elif is_on_floor() and direcao < 0:
				ANIMACOES.flip_h = true
				ANIMACOES.play("andando")
				
			elif is_on_floor() and direcao > 0:
				ANIMACOES.flip_h = false
				ANIMACOES.play("andando")
		
		
		ESTADOS.NA_PAREDE:
			if is_on_floor():
				ESTADO_PLAYER = ESTADOS.NO_CHAO
			
			elif not (DETECTOR_PAREDE_DIREITA.is_colliding() or DETECTOR_PAREDE_ESQUERDA.is_colliding()):
				ESTADO_PLAYER = ESTADOS.NO_AR
			
			else:
				PULOU_DA_PAREDE = false
				descer_devagar = true
				normal_da_ultima_parede = get_wall_normal()
				aplicar_gravidade(delta, descer_devagar)
				aplicar_aceleracao_fora_do_chao(direcao, delta)
				aplicar_friccao_fora_do_chao(direcao)
				aplicar_wall_jump(normal_da_ultima_parede)
			
			if not is_on_floor() and DETECTOR_PAREDE_DIREITA.is_colliding():
				ANIMACOES.play("parede")
				ANIMACOES.flip_h = false
			
			elif not is_on_floor() and DETECTOR_PAREDE_ESQUERDA.is_colliding():
				ANIMACOES.play("parede")
				ANIMACOES.flip_h = true
	
	move_and_slide() # mova o personagem
	
	if (estava_no_chao == is_on_floor()) and (not is_on_floor()):
		PULO_COYOTE_TIMER.start()
	
	elif ((estava_na_parede_esquerda == DETECTOR_PAREDE_DIREITA.is_colliding()) and (not DETECTOR_PAREDE_DIREITA.is_colliding())) or ((estava_na_parede_direita == DETECTOR_PAREDE_ESQUERDA.is_colliding()) and (not DETECTOR_PAREDE_ESQUERDA.is_colliding())):
		WALL_JUMP_TIMER.start()


func _on_zona_da_morte_body_entered(_body: Node2D) -> void:
	# ADICIONAR ANIMAÇÃO DE MORTE AQUI
	global_position = ULTIMO_CHECKPOINT


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


func _on___checkpoint_1_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	ULTIMO_CHECKPOINT = Vector2(CHECKPOINT_1.global_position)
	
	# Checa se a transição de cenário já está acontecendo e a destroi se sim
	if tween_atual:
		tween_atual.kill()

	tween_atual = create_tween() # Cria transição
	tween_atual.set_parallel() # Faz com que as transições ocorrem simultaneamente e não sequencialmente
	
	# Transições:
	transicao_cenario(tween_atual, $"../ParallaxBackground/Ceu/PlanoDeFundo", 1.5, 4.0)
	transicao_cenario(tween_atual, $"../ParallaxBackground/1-GirassoisDeFrente/Sprite2D", 1.5, 4.0)
	transicao_cenario(tween_atual, $"../ParallaxBackground/2-GirassoisDoMeio/Sprite2D", 1.5, 4.0)
	transicao_cenario(tween_atual, $"../ParallaxBackground/3-GirassoisMaisDeFundo/Sprite2D", 1.5, 4.0)
	
	# Para quando o jogador voltar para o checkpoint:
	transicao_reversa = !transicao_reversa
	
	CHECKPOINT_1.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_play_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT ATINGIDO DEPOIS
	CHECKPOINT_2.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	CHECKPOINT_3.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS


func _on___checkpoint_2_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	ULTIMO_CHECKPOINT = Vector2(CHECKPOINT_2.global_position)
	
	CHECKPOINT_2.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_play_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT ATINGIDO DEPOIS
	CHECKPOINT_1.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	CHECKPOINT_3.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS


func _on___checkpoint_3_body_entered(body: Node2D) -> void:
	if body.name != "Player":
		return
	
	ULTIMO_CHECKPOINT = Vector2(CHECKPOINT_3.global_position)
	
	CHECKPOINT_3.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_play_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT ATINGIDO DEPOIS
	CHECKPOINT_1.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	CHECKPOINT_2.get_node("Sprite2D").texture = load("res://Assets/Imagens/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS

func transicao_cenario(tween_atual: Tween, sprite: Node, tempo_transicao: float, desfoque_quant: float):
	if !transicao_reversa:
		tween_atual.tween_property(sprite.material, 'shader_parameter/desfoque_quant', desfoque_quant, tempo_transicao)
		tween_atual.tween_property(sprite.material, 'shader_parameter/transicao', 1, tempo_transicao)
	else:
		tween_atual.tween_property(sprite.material, 'shader_parameter/desfoque_quant', 0, tempo_transicao)
		tween_atual.tween_property(sprite.material, 'shader_parameter/transicao', 0, tempo_transicao)
