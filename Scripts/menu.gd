extends Control

@onready var jogar_sprite: Sprite2D = $JogarSprite
@onready var saida_sprite: Sprite2D = $SaidaSprite

func _on_button_pressed() -> void: # Jogar
	get_tree().change_scene_to_file("res://Scenes/jogo.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()


func _on_jogar_mouse_entered() -> void:
	jogar_sprite.texture = load("res://Assets/Imagens/jogar_3.png")


func _on_jogar_mouse_exited() -> void:
	jogar_sprite.texture = load("res://Assets/Imagens/jogar_2.png")


func _on_sair_mouse_entered() -> void:
	saida_sprite.texture = load("res://Assets/Imagens/saida_3.png")


func _on_sair_mouse_exited() -> void:
	saida_sprite.texture = load("res://Assets/Imagens/saida_2.png")
