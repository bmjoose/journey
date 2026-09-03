extends CharacterBody2D

const SPEED = 300.0

# Agora a direção é um Vector2 (guarda tanto o X quanto o Y do alvo)
var direction: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Move a moeda na velocidade máxima multiplicada pela direção do alvo
	velocity = direction * SPEED
	
	# Vira o sprite horizontalmente baseado no lado para onde ela está voando
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.flip_h = (velocity.x < 0)
	elif has_node("Sprite2D"):
		$Sprite2D.flip_h = (velocity.x < 0)

	move_and_slide()

# Destrói a moeda ao sair da tela para não pesar o jogo
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
