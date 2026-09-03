extends Area2D

var velocidade = 350.0 
var direcao = 1

func _ready() -> void:
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if direcao == 1: 
		global_position.x += velocidade * delta
		$Sprite2D.flip_h = false 
	else:
		global_position.x -= velocidade * delta
		$Sprite2D.flip_h = true

func _on_body_entered(body: Node2D) -> void:
	
	if body.name == "personagem":
		return

	if body.has_method("sofrer_dano"):
		body.sofrer_dano() 
		queue_free()       
		return        
	queue_free() 

func _on_area_entered(area: Area2D) -> void:
	if area.owner and area.owner.has_method("sofrer_dano"):
		area.owner.sofrer_dano()
		queue_free()
func colisao_cenario():
	queue_free()
func _on_timer_timeout() -> void:
	queue_free()
