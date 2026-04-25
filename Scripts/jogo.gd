extends Node2D

#var transicao_reversa = false
#var tween_atual: Tween
#
#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("pular"):
		#if tween_atual:
			#tween_atual.kill()
#
		#tween_atual = create_tween()
		#tween_atual.set_parallel()
#
		#if !transicao_reversa:
			#tween_atual.tween_property($ParallaxBackground/Ceu/PlanoDeFundo.material, 'shader_parameter/desfoque_quant', 4.0, 1.5)
			#tween_atual.tween_property($ParallaxBackground/Ceu/PlanoDeFundo.material, 'shader_parameter/transicao', 1, 1.5)
			#
			#tween_atual.tween_property($"ParallaxBackground/1-GirassoisDeFrente/Sprite2D".material, 'shader_parameter/desfoque_quant', 4.0, 1.5)
			#tween_atual.tween_property($"ParallaxBackground/1-GirassoisDeFrente/Sprite2D".material, 'shader_parameter/transicao', 1, 1.5)
			#
			#tween_atual.tween_property($"ParallaxBackground/2-GirassoisDoMeio/Sprite2D".material, 'shader_parameter/desfoque_quant', 4.0, 1.5)
			#tween_atual.tween_property($"ParallaxBackground/2-GirassoisDoMeio/Sprite2D".material, 'shader_parameter/transicao', 1, 1.5)
			#
			#tween_atual.tween_property($"ParallaxBackground/3-GirassoisMaisDeFundo/Sprite2D".material, 'shader_parameter/desfoque_quant', 4.0, 1.5)
			#tween_atual.tween_property($"ParallaxBackground/3-GirassoisMaisDeFundo/Sprite2D".material, 'shader_parameter/transicao', 1, 1.5)
			#
			#transicao_reversa = true
		#else:
			#tween_atual.tween_property($ParallaxBackground/Ceu/PlanoDeFundo.material, 'shader_parameter/desfoque_quant', 0, 1.5)
			#tween_atual.tween_property($ParallaxBackground/Ceu/PlanoDeFundo.material, 'shader_parameter/transicao', 0, 1.5)
			#
			#tween_atual.tween_property($"ParallaxBackground/1-GirassoisDeFrente/Sprite2D".material, 'shader_parameter/desfoque_quant', 0, 1.5)
			#tween_atual.tween_property($"ParallaxBackground/1-GirassoisDeFrente/Sprite2D".material, 'shader_parameter/transicao', 0, 1.5)
			#
			#tween_atual.tween_property($"ParallaxBackground/2-GirassoisDoMeio/Sprite2D".material, 'shader_parameter/desfoque_quant', 0, 1.5)
			#tween_atual.tween_property($"ParallaxBackground/2-GirassoisDoMeio/Sprite2D".material, 'shader_parameter/transicao', 0, 1.5)
			#
			#tween_atual.tween_property($"ParallaxBackground/3-GirassoisMaisDeFundo/Sprite2D".material, 'shader_parameter/desfoque_quant', 0, 1.5)
			#tween_atual.tween_property($"ParallaxBackground/3-GirassoisMaisDeFundo/Sprite2D".material, 'shader_parameter/transicao', 0, 1.5)
			#
			#transicao_reversa = false
