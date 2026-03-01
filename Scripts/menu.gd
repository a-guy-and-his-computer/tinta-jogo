extends Control

func _on_button_pressed() -> void: # Jogar
	get_tree().change_scene_to_file("res://Scenes/jogo.tscn")


func _on_button_2_pressed() -> void: # Config
	pass


func _on_sair_pressed() -> void:
	get_tree().quit()
