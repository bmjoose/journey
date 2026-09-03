extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var wall_ray: RayCast2D = $wallDetector
@onready var spawn: Node2D = $moedaBoleto

const MOEDA_SCENE = preload("res://cena_moeda_boleto.tscn")

@export var speed := 80.0
@export var attack_range := 120.0
@export var vida_maxima := 6 # <-- Configurei a vida aqui (pode mudar para 5 no editor se quiser)

var direcao := 1
var player = null
var atacando := false
var ja_atirou := false
var vida_atual := 0 # Variável que vai controlar a vida atual dele


func _ready():
	anim.play("andando")
	vida_atual = vida_maxima # Inicia o boleto com a vida cheia


func _physics_process(delta):
	# gravidade
	if not is_on_floor():
		velocity.y += 600 * delta
	else:
		velocity.y = 0

	# IA simples (Movimentação do Boleto)
	if player:
		var dist = global_position.distance_to(player.global_position)

		if dist <= attack_range:
			attack_state()
		else:
			chase_state()
	else:
		walk_state()

	# movimento
	move_and_slide()

	# parede (Verificação do Boleto)
	check_wall()


# ---------------- ESTADOS (MOVIMENTAÇÃO DO BOLETO) ----------------

func walk_state():
	atacando = false
	velocity.x = speed * direcao
	anim.play("andando")


func chase_state():
	atacando = false

	# Descobre para onde o player está
	var direcao_para_player = sign(player.global_position.x - global_position.x)
	
	# Se a direção do player mudou em relação à direção atual do boleto, vira ele!
	if direcao_para_player != 0 and direcao_para_player != direcao:
		reverter_direcao()

	velocity.x = speed * direcao
	anim.play("andando")


func attack_state():
	atacando = true
	velocity.x = 0

	anim.play("ataque")

	# Garante que ele vire para o player antes de atirar se o player pular atrás dele
	if player:
		var direcao_para_player = sign(player.global_position.x - global_position.x)
		if direcao_para_player != 0 and direcao_para_player != direcao:
			reverter_direcao()

	if anim.frame == 5 and not ja_atirou:
		atirar_moeda()
		ja_atirou = true

	if anim.frame != 5:
		ja_atirou = false


# ---------------- PAREDE ----------------

func check_wall():
	if wall_ray == null:
		return

	# Como usamos o scale.x do Zumbi, o RayCast vira sozinho! Deixamos o valor original do Inspetor fixo:
	wall_ray.target_position = Vector2(38, -1)

	if wall_ray.is_colliding():
		reverter_direcao()


# ---------------- INVERSÃO DE DIREÇÃO (SISTEMA DO ZUMBI) ----------------

func reverter_direcao():
	direcao *= -1
	scale.x *= -1


# ---------------- ATAQUE ----------------

func atirar_moeda():
	var moeda = MOEDA_SCENE.instantiate()
	get_parent().add_child(moeda)

	# Como a escala vira por completo, a posição global do spawn sempre estará correta!
	moeda.global_position = spawn.global_position
	moeda.direction = direcao


# ---------------- DETECÇÃO DE VISÃO DO BOLETO ----------------

func _on_player_detector_body_entered(body):
	if body.name == "personagem":
		player = body


func _on_player_detector_body_exited(body):
	if body == player:
		player = null


# ---------------- COLISÃO E DANOS (SISTEMA DE HITBOX DO ZUMBI) ----------------

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == "personagem":
		if body.has_method("tomar_dano"):
			
			# Lógica do Zumbi: Se o personagem estiver defendendo, o boleto bate e volta!
			if "defendendo" in body and body.defendendo:
				reverter_direcao()
				return
				
			# Se não estiver defendendo, aplica o dano do seu personagem
			body.tomar_dano(1)
			print("Boleto causou dano no personagem!")


# Chamada quando o jogador acerta o boleto (ex: com o livro)
func sofrer_dano():
	vida_atual -= 1
	print("Boleto levou dano! Vida restante: ", vida_atual)
	
	# Só morre se a vida acabar
	if vida_atual <= 0:
		print("Boleto foi destruído!")
		queue_free()
