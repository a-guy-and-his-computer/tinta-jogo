extends Area2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var checkpoints: Node2D = $".."


func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.name != "Player":
		return
	
	player.checkpoint_entrado(global_position);
	
	# Pegue o número no começo do nome do checkpoint
	# PRECISA ESTAR NO FORMATO "n - Checkpoint"
	var num_checkpoint_atual = int(self.name.split(" - ")[0])
	var num = num_checkpoint_atual - 1
	var checkpoint_adjacente = "%d - Checkpoint" % num
	
	# TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	if checkpoints.has_node(checkpoint_adjacente):
		checkpoints.get_node(checkpoint_adjacente).get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png")
	
	# TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT ATINGIDO DEPOIS
	checkpoints.get_node("%d - Checkpoint" % num_checkpoint_atual).get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_play_2.png")
	
	# TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	num += 2
	checkpoint_adjacente = "%d - Checkpoint" % num
	if checkpoints.has_node(checkpoint_adjacente):
		checkpoints.get_node(checkpoint_adjacente).get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png")
