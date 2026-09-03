extends Node2D

const WAIT_DURATION: float = 1.0

@export var move_speed: float = 100.0
@export var distance: float = 192.0
@export var horizontal: bool = true

@onready var platform: AnimatableBody2D = $platform

var start_position: Vector2
var target_position: Vector2

func _ready() -> void:
	start_position = platform.position

	if horizontal:
		target_position = start_position + Vector2(distance, 0)
	else:
		target_position = start_position + Vector2(0, distance)

	start_movement()


func start_movement() -> void:
	var duration := start_position.distance_to(target_position) / move_speed

	var tween := create_tween()
	tween.set_loops()

	# Vai até o alvo
	tween.tween_property(
		platform,
		"position",
		target_position,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_interval(WAIT_DURATION)

	# Volta para o início
	tween.tween_property(
		platform,
		"position",
		start_position,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_interval(WAIT_DURATION)
