extends Node


#func _on___checkpoint_1_body_entered(body: Node2D) -> void:
	#if body.name != "Player":
		#return
	#
	#ULTIMO_CHECKPOINT = Vector2(CHECKPOINT_1.global_position)
	#
	## Checa se a transição de cenário já está acontecendo e a destroi se sim
	#if tween_transicao_cenario:
		#tween_transicao_cenario.kill()
#
	#tween_transicao_cenario = create_tween() # Cria transição
	#tween_transicao_cenario.set_parallel() # Faz com que as transições ocorrem simultaneamente e não sequencialmente
	#
	## Transições:
	#transicao_cenario(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo", 1.5, 4.0)
	#transicao_cenario(tween_transicao_cenario, $"../ParallaxBackgroundDia/1-GirassoisDeFrente/Sprite2D", 1.5, 4.0)
	#transicao_cenario(tween_transicao_cenario, $"../ParallaxBackgroundDia/2-GirassoisDoMeio/Sprite2D", 1.5, 4.0)
	#transicao_cenario(tween_transicao_cenario, $"../ParallaxBackgroundDia/3-GirassoisMaisDeFundo/Sprite2D", 1.5, 4.0)
	#
	#transicao_visibilidade_sprite(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo/Sol", 1.5, 1)
	#transicao_visibilidade_sprite(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo/Sol/BrilhoSol", 1.5, 0.584)
	#transicao_visibilidade_shader(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo/Sol/LuzDoSol", 1.5)
	#transicao_visibilidade_shader(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo/Sol/LuzDoSol2", 1.5)
	#transicao_visibilidade_shader(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo/Sol/LuzDoSol3", 1.5)
	#transicao_visibilidade_shader(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo/Sol/LuzDoSol4", 1.5)
	#transicao_visibilidade_shader(tween_transicao_cenario, $"../ParallaxBackgroundDia/Ceu/PlanoDeFundo/Sol/LuzDoSol5", 1.5)
	#
	## Para quando o jogador voltar para o checkpoint:
	#transicao_cenario_reversa = !transicao_cenario_reversa
	#
	#CHECKPOINT_1.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_play_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT ATINGIDO DEPOIS
	#CHECKPOINT_2.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	#CHECKPOINT_3.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS

#func _on___checkpoint_2_body_entered(body: Node2D) -> void:
	#if body.name != "Player":
		#return
	#
	#ULTIMO_CHECKPOINT = Vector2(CHECKPOINT_2.global_position)
	#
	#CHECKPOINT_2.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_play_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT ATINGIDO DEPOIS
	#CHECKPOINT_1.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	#CHECKPOINT_3.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
#
#func _on___checkpoint_3_body_entered(body: Node2D) -> void:
	#if body.name != "Player":
		#return
	#
	#ULTIMO_CHECKPOINT = Vector2(CHECKPOINT_3.global_position)
	#
	#CHECKPOINT_3.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_play_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT ATINGIDO DEPOIS
	#CHECKPOINT_1.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS
	#CHECKPOINT_2.get_node("Sprite2D").texture = load("res://Assets/Imagens/Menus/celo_video_2.png") # TEMPORARIO! TROCAR POR ASSETS DE CHECKPOINT NÃO ATINGIDO DEPOIS


#func transicao_cenario(tween_atual: Tween, sprite: Node, tempo_transicao: float, desfoque_quant: float):
	#if !transicao_cenario_reversa:
		#tween_atual.tween_property(sprite.material, 'shader_parameter/desfoque_quant', desfoque_quant, tempo_transicao)
		#tween_atual.tween_property(sprite.material, 'shader_parameter/transicao', 1, tempo_transicao)
	#else:
		#tween_atual.tween_property(sprite.material, 'shader_parameter/desfoque_quant', 0, tempo_transicao)
		#tween_atual.tween_property(sprite.material, 'shader_parameter/transicao', 0, tempo_transicao)
#
#func transicao_visibilidade_shader(tween_atual: Tween, sprite: Node, tempo_transicao: float):
	#if !transicao_cenario_reversa:
		#tween_atual.tween_property(sprite.material, 'shader_parameter/intens_geral', 0, tempo_transicao)
	#else:
		#tween_atual.tween_property(sprite.material, 'shader_parameter/intens_geral', 1, tempo_transicao)
#
#func transicao_visibilidade_sprite(tween_atual: Tween, sprite: Node, tempo_transicao: float, alpha: float):
	#if !transicao_cenario_reversa:
		#tween_atual.tween_property(sprite, 'modulate:a', 0.0,  tempo_transicao)
	#else:
		#tween_atual.tween_property(sprite, 'modulate:a', alpha,  tempo_transicao)
