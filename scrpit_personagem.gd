extends CharacterBody2D

@onready var animacao: AnimatedSprite2D = $personagem
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hitbox = $hitbox

var velocidade = 250.0
var forca_pulo = 510.0
var gravidade = 30
var morreu = false
var esta_atacando: bool = false
var livro_spawnado = false
var defendendo = false

func _physics_process(delta: float) -> void:
	
	if morreu:
		return
	velocity.y += gravidade
	if Input.is_action_pressed("ui_down") and not esta_atacando:
		defendendo = true
		velocity.x = 0
		if hitbox:
			hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		if animacao.animation != "defesa":
			animacao.play("defesa")
		if animacao.frame >= 3:
			animacao.stop()
			animacao.frame = 3
	else:
		defendendo = false
		if hitbox:
			hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	if not esta_atacando and not defendendo:
		if Input.is_action_pressed("ui_left"):
			velocity.x = -velocidade
			animacao.flip_h = true
			$Marker2D.scale.x = -1
			$Area2D.scale.x = -1
		elif Input.is_action_pressed("ui_right"):
			velocity.x = velocidade
			animacao.flip_h = false
			$Marker2D.scale.x = 1
			$Area2D.scale.x = 1
		else:
			velocity.x = 0
		if Input.is_action_just_pressed("ui_up") and is_on_floor():
			velocity.y = -forca_pulo

	if Input.is_action_just_pressed("atacar"):
		if esta_atacando:
			return
		if Global.qtd_livros <= 0:
			return
		Global.qtd_livros -= 1
		iniciar_ataque("atacando_livro")
	elif Input.is_action_just_pressed("atacar_mochila"):
		if esta_atacando or defendendo:
			return
		iniciar_ataque("atacando_mochila")

	if not esta_atacando and not defendendo:
		if not is_on_floor():
			animacao.play("pulando")
		else:
			if velocity.x != 0:
				animacao.play("correndo")
			else:
				if animacao.sprite_frames.has_animation("parado"):
					animacao.play("parado")
				else:
					animacao.play("default")
	if esta_atacando and animacao.animation == "atacando_livro":
		if animacao.frame == 3 and not livro_spawnado:
			livro_spawnado = true
			spawnar_livro()
	move_and_slide()

func dano_no_inimigo(body: Node2D) -> void:
	if not esta_atacando:
		return
	if body.has_method("sofrer_dano"):
		body.sofrer_dano()

func tomar_dano(quantidade: int):
	if morreu or defendendo:
		return
	Global.qtd_vidas -= quantidade
	if Global.qtd_vidas <= 0:
		Global.qtd_vidas = 0
		morrer()

func morrer():
	morreu = true
	velocity = Vector2.ZERO	
	animacao.play("morrendo")
	await animacao.animation_finished
	get_tree().change_scene_to_file("res://cena_game_over.tscn")

func iniciar_ataque(nome_ataque: String):
	esta_atacando = true
	livro_spawnado = false
	animacao.play(nome_ataque)
	if animation_player.has_animation(nome_ataque):
		animation_player.play(nome_ataque)

	var quantidade_frames = animacao.sprite_frames.get_frame_count(nome_ataque)
	var fps = animacao.sprite_frames.get_animation_speed(nome_ataque)
	var tempo = quantidade_frames / fps

	await get_tree().create_timer(tempo).timeout

	esta_atacando = false
	livro_spawnado = false

func spawnar_livro():
	var cena_livro = preload("res://cena_livro.tscn")
	var objeto_livro = cena_livro.instantiate()
	if not animacao.flip_h:
		objeto_livro.get_node("Area2D").direcao = 1
	else:
		objeto_livro.get_node("Area2D").direcao = -1
	add_sibling(objeto_livro)
	objeto_livro.global_position = $Marker2D.global_position

func curar():
	Global.qtd_vidas += 1
	Global.qtd_vidas = clamp(Global.qtd_vidas, 0, Global.max_vidas)
