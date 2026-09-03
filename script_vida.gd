extends Area2D

func coletar_vida(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.qtd_vidas += 1
		Global.qtd_vidas = clamp(Global.qtd_vidas, 0, Global.max_vidas)

		queue_free()
