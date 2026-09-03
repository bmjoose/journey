extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

const MOEDA_SCENE = preload("res://cena_moeda_boleto.tscn")

@export var speed := 80.0
@export var attack_range := 200.0

var direcao := 1
var player = null
var tempo_ultimo_tiro := 0.0
var intervalo_tiro := 1.5 # Tempo em segundos entre cada tiro

func _physics_process(delta: float) -> void:
	# Gravidade simples
	if not is_on_floor():
		velocity.y += 600 * delta
	else:
		velocity.y = 0

	# Tenta encontrar o personagem se ele ainda não foi detectado
	if not player and get_parent().has_node("personagem"):
		player = get_parent().get_node("personagem")

	# IA de perseguição e tiro
	if player:
		var dist = global_position.distance_to(player.global_position)
		
		# Define o lado certo para olhar baseado no player
		var direcao_para_player = sign(player.global_position.x - global_position.x)
		if direcao_para_player != 0 and direcao_para_player != direcao:
			direcao = direcao_para_player
			scale.x *= -1 # Vira o corpo todo de lado de forma limpa

		if dist <= attack_range:
			velocity.x = 0
			if anim: anim.play("ataque")
			
			# Lógica do temporizador do tiro
			tempo_ultimo_tiro += delta
			if tempo_ultimo_tiro >= intervalo_tiro:
				atirar()
				tempo_ultimo_tiro = 0.0
		else:
			velocity.x = speed * direcao
			if anim: anim.play("andando")
	else:
		velocity.x = speed * direcao
		if anim: anim.play("andando")

	move_and_slide()

func atirar() -> void:
	# Só atira se o player existir na cena
	if player == null:
		return
		
	var obj_bala = MOEDA_SCENE.instantiate()
	
	# Define a posição inicial de onde a moeda vai surgir
	var posicao_spawn: Vector2
	if has_node("Marker2D"):
		posicao_spawn = $Marker2D.global_position
	else:
		posicao_spawn = global_position
		
	obj_bala.global_position = posicao_spawn

	# MÁGICA AQUI: Calcula a direção exata entre o spawn da bala e a posição do player
	# O '.normalized()' garante que o vetor tenha tamanho 1, servindo apenas como "guia" de direção
	var direcao_do_tiro = (player.global_position - posicao_spawn).normalized()
	
	# Passa o vetor calculado para a moeda
	obj_bala.direction = direcao_do_tiro
	
	# Adiciona a moeda no mundo
	get_parent().add_child(obj_bala)
