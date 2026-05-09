extends Area2D

@onready var player: CharacterBody2D = $"../../Player"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.name != "Player":
		return
	
	player.morte();
