extends Area2D

func go_to_fase2() -> void:
	get_tree().change_scene_to_file("res://cena_fase2.tscn")

func go_to_fase3() -> void:
	get_tree().change_scene_to_file("res://cena_fase3.tscn")
	
func go_to_parabens():
	get_tree().change_scene_to_file("res://tela_ganhou.tscn")

func passar_fase(body: Node2D) -> void:
	if body.is_in_group("player"):
		var caminho_cena = get_tree().current_scene.scene_file_path

		if "cena_fase.tscn" in caminho_cena:
			go_to_fase2()
		if "cena_fase2.tscn" in caminho_cena:
			go_to_fase3()
		elif "cena_fase3.tscn" in caminho_cena:
			go_to_parabens()

func _on_body_entered(body):
	passar_fase(body)
