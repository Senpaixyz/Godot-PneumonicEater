extends Area2D

var dragging = false

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			print("HELLO")
		if event.is_action_released("click"):
			print("POS", get_parent().position)
		if event.is_pressed():
			dragging = true
		else:
			dragging = false
	elif event is InputEventMouseMotion and dragging:
		get_parent().position = get_global_mouse_position()
