extends Node2D


func continuar_jogo() -> void:
	Global.inicializar()
	get_tree().change_scene_to_file("res://cena_fase.tscn")
	



func ir_para_inicio() -> void:
	Global.inicializar()
	get_tree().change_scene_to_file("res://prefabs/tela_inicial.tscn")
