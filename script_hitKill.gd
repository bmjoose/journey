extends Area2D


func hitKill(body: Node2D) -> void:
	get_tree().change_scene_to_file("res://cena_game_over.tscn")
