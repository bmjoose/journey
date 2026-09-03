extends CharacterBody2D

enum zumbiState {
	andando,
	morrendo
}

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $hitbox
@onready var wall_detector: RayCast2D = $wallDetector
@onready var ground_detector: RayCast2D = $groundDetector
@onready var player_detector: RayCast2D = $playerDetector

const SPEED = 25.0

var status: zumbiState
var direcao = 1
var qnt_vida = 2

func _ready() -> void:
	go_to_andando_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	
	if qnt_vida <= 0 and status != zumbiState.morrendo:
		go_to_morrendo_state()
		
	match status:
		zumbiState.andando:
			andando_state(delta)
		zumbiState.morrendo:
			morrendo_state(delta)
			
	move_and_slide()

func go_to_andando_state():
	status = zumbiState.andando
	if anim:
		anim.play("andando")

func go_to_morrendo_state():
	if status == zumbiState.morrendo: 
		return
		
	status = zumbiState.morrendo
	velocity = Vector2.ZERO 
	
	if hitbox:
		hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func andando_state(_delta):
	velocity.x = SPEED * direcao
	
	if wall_detector and wall_detector.is_colliding():
		reverter_direcao()
		return

	if ground_detector and not ground_detector.is_colliding():
		reverter_direcao()
		return

func morrendo_state(_delta):
	if anim and anim.animation != "morrendo":
		anim.play("morrendo")
		await anim.animation_finished
		queue_free()

func sofrer_dano():
	qnt_vida -= 1 

func reverter_direcao():
	direcao *= -1
	scale.x *= -1

func _on_hitbox_body_entered(body: Node2D) -> void:

	if body.has_method("tomar_dano"):

		if "defendendo" in body and body.defendendo:
			reverter_direcao()
			return
		body.tomar_dano(1)
		qnt_vida = 0
