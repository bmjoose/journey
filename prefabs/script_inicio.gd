extends Node2D

func iniciar_jogo() -> void:
	Global.inicializar()
	get_tree().change_scene_to_file("res://cena_fase.tscn")
