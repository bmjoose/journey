extends Area2D

var coin := 1

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func moeda_coletada(body: Node2D) -> void:
	if (body.name=="personagem"):
		Global.qtd_moedas += 1
		
		# $AudioStreamPlayer.play()
		queue_free()
		
