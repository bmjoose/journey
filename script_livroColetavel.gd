extends Area2D


func coletar_livro(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.qtd_livros += 1
		queue_free()
