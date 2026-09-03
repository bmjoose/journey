extends Node2D


func voltar_inicio() -> void:
	Global.inicializar()
	get_tree().change_scene_to_file("res://prefabs/tela_inicial.tscn")
