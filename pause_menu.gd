extends CanvasLayer

@onready var resume_button: Button = $menu/resume_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		resume_button.grab_focus()

func button_pressed_resume() -> void:
	get_tree().paused = false
	visible = false


func button_pressed_quit() -> void:
	get_tree().quit()
