extends KinematicBody2D

var dragging = false
var is_spawning = false
var get_color = false
var list = []
var mouse_pos = Vector2()
var color = Color(0.5,1.2,.90,0.1)
const MAX_SPEED = 15
var Move = Vector2()
onready var Analog = $Joystick/Analog

func _ready():
	set_process_input(true)
func _physics_process(delta):
	update()
	
	move_and_collide(Move)
func _input(event):
	if event is InputEventMouseButton:
		if event.is_action_pressed("click"):
			dragging = true
		else:
			dragging = false
		if event.is_action_released("click"):
			for i in list:
				match i:
					"Neutrophils":
						pass
						#PlayerInstance.spawn_Character("Neutrophils",get_parent().get_node("PlayerStart").global_position)
					"Monocytes":
						pass
						#PlayerInstance.spawn_Character("Monocytes",get_parent().get_node("PlayerStart").global_position)
					"Basophils":
						pass
					"Eosinophils":
						pass
			list.clear()
			dragging = false
			is_spawning = false
func _on_MenuPress_spawn_character(val):
	for i in val:
		list.append(i)
	val.clear()
	return list
	
func _on_MenuPress_building_mode(mode,mode2):
	dragging = mode
	is_spawning = mode2


func _on_Camera_draw():
	if is_spawning:
		draw_circle($Camera2D.position,2000,color)

