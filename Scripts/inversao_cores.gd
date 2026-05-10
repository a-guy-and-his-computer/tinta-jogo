extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var tile_map_invertido: TileMapLayer = $TileMapInvertido
@onready var tela: ColorRect = $CanvasLayer/Tela
@onready var canvas_layer_imutavel: SubViewport = $CanvasLayerImutavel

const max_raio = 2
const velocidade = 2.5

var inversao = true
var direcao = -1
var raio = 0

#func _ready() -> void:
	#tela.transform.size = get_viewport().get_visible_rect().size
	#canvas_layer_imutavel.size = get_viewport().get_visible_rect().size
	#
	#

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("inverter"):
		inversao = !inversao
		
		player.set_collision_layer_value(1, inversao)
		player.set_collision_mask_value(1, inversao)
		player.set_collision_layer_value(2, !inversao)
		player.set_collision_mask_value(2, !inversao)
		
		# Se a pessoa apertar de novo o circulo reverte
		direcao *= -1
		
	# O circulo aumenta a cada frame mas nunca excede o tamanho max_raio
	raio += direcao * velocidade * delta
	raio = clamp(raio, 0.0, max_raio)
		
	# Pega onde o jogador está no UV da tela
	var tamanho_tela = get_viewport().get_visible_rect().size
	var posicao_jogador_tela = player.get_global_transform_with_canvas().origin
	var posicao_uv_tela = posicao_jogador_tela / tamanho_tela
		
	# Coloca o circulo na posição onde o jogador está
	tela.material.set_shader_parameter("inversao_centro", posicao_uv_tela)
	tela.material.set_shader_parameter("raio", raio)
