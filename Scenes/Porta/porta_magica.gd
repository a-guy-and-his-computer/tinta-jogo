extends Area2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var spawn_point: Marker2D = $"../SpawnPoint"
@onready var parallax_background_dia: Node2D = $"../../ParallaxBackgroundDia"
@onready var parallax_background_noite: Node2D = $"../../ParallaxBackgroundNoite"
@onready var tela: CanvasLayer = $"../../CanvasLayer"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.name != "Player":
		return
	
	player.global_position = spawn_point.global_position
	
	parallax_background_dia.visible = false
	tela.visible = false
	parallax_background_noite.visible = true
	
	# MANTER ANIMATEDSPRITE2D COMO A PRIMEIRA CENA
	player.get_child(0).material.set_shader_parameter('nitidez_ligado', true)
	player.get_child(0).material.set_shader_parameter('noite_ligada', true)
