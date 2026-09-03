extends Control

@onready var coins_counter: Label = $MarginContainer/coins_container/coins_icon/coins_counter as Label
@onready var heart_life: Label = $MarginContainer/heart_container2/heart_icon/heart_life as Label
@onready var livro_counter: Label = $MarginContainer/livro_container2/livro_icon/livro_counter as Label

func _ready() -> void:
	coins_counter.text = str("%04d" % Global.qtd_moedas)
	heart_life.text = str("%04d" % Global.qtd_vidas)
	livro_counter.text = str("%04d" % Global.qtd_livros)
	
func _process(delta: float) -> void:
	coins_counter.text = str("%04d" % Global.qtd_moedas)
	heart_life.text = str("%04d" % Global.qtd_vidas)
	livro_counter.text = str("%04d" % Global.qtd_livros)
