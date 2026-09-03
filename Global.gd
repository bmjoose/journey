extends Node

var max_vidas : int = 5
var qtd_vidas : int = max_vidas
var qtd_moedas : int = 0
var qtd_livros : int = 4
var personagem = null

func inicializar():
	qtd_vidas = 3
	qtd_livros = 4
func _ready() -> void:
	inicializar()
	
