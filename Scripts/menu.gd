extends Control

@onready var JOGAR_SPRITE: Sprite2D = $Jogar/JogarSprite
@onready var SAIDA_SPRITE: Sprite2D = $Sair/SaidaSprite
@onready var CONTROLES_SPRITE: Sprite2D = $ControlesConfig/ControlesSprite
@onready var DISPLAY_SPRITE: Sprite2D = $DisplayConfig/DisplaySprite
@onready var SOM_SPRITE: Sprite2D = $SomConfig/SomSprite

func _on_button_pressed() -> void: # Jogar
	get_tree().change_scene_to_file("res://Scenes/van_gogh.tscn")


func _on_sair_pressed() -> void: # Sair
	get_tree().quit()


func _on_controles_botao_pressed() -> void: # Controles
	GameState.abrir_aba = "controles"
	GameState.origem = "menu"
	get_tree().change_scene_to_file("res://Scenes/configuracoes.tscn")


func _on_display_botao_pressed() -> void: # Display
	GameState.abrir_aba = "video"
	GameState.origem = "menu"
	get_tree().change_scene_to_file("res://Scenes/configuracoes.tscn")


func _on_som_botao_pressed() -> void: # Som
	GameState.abrir_aba = "volume"
	GameState.origem = "menu"
	get_tree().change_scene_to_file("res://Scenes/configuracoes.tscn")


func _on_jogar_mouse_entered() -> void:
	JOGAR_SPRITE.texture = load("res://Assets/Imagens/Menus/jogar_3.png")


func _on_jogar_mouse_exited() -> void:
	JOGAR_SPRITE.texture = load("res://Assets/Imagens/Menus/jogar_2.png")


func _on_sair_mouse_entered() -> void:
	SAIDA_SPRITE.texture = load("res://Assets/Imagens/Menus/saida_3.png")


func _on_sair_mouse_exited() -> void:
	SAIDA_SPRITE.texture = load("res://Assets/Imagens/Menus/saida_2.png")


func _on_controles_botao_mouse_entered() -> void:
	CONTROLES_SPRITE.texture = load("res://Assets/Imagens/Menus/celo_controles_2.png")

func _on_controles_botao_mouse_exited() -> void:
	CONTROLES_SPRITE.texture = load("res://Assets/Imagens/Menus/celo_controles_1.png")


func _on_display_botao_mouse_entered() -> void:
	DISPLAY_SPRITE.texture = load("res://Assets/Imagens/Menus/celo_video_2.png")


func _on_display_botao_mouse_exited() -> void:
	DISPLAY_SPRITE.texture = load("res://Assets/Imagens/Menus/celo_video_1.png")


func _on_som_botao_mouse_entered() -> void:
	SOM_SPRITE.texture = load("res://Assets/Imagens/Menus/celo_musica.png")


func _on_som_botao_mouse_exited() -> void:
	SOM_SPRITE.texture = load("res://Assets/Imagens/Menus/celo_musica111.png")
