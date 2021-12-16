extends Camera2D

var min_zoom = 1
var max_zoom = 3
var zoom_sensitivity = 10
var zoom_speed = 0.05
var events = {}
var last_drag_distance = 0
signal area_selected
signal start_move_selection
############FOR DEBUGGING###############################3
export var panSpeed = 10.0
export var speed = 10.0
export var zoomspeed = 10.0

export var zoomMin = 0.25
export var zoomMax = 3.0
export var marginX = 200.0
export var marginY = 200.0
var mousepos = Vector2()
var mouseposGlobal = Vector2()
var start = Vector2()
var startv = Vector2()
var end = Vector2()
var endv = Vector2()
var zoomfactor = 1.0
var zooming = false
var is_dragging = false
var move_to_point = Vector2()
var selecting = false
var is_moving = true
onready var rectd = get_parent().get_parent().get_node("UPPERPANEl/drawrect")

func _ready():
	print(get_parent().get_parent().name)
	connect("area_selected", get_parent().get_parent(), "area_selected", [self])
	connect("start_move_selection", get_parent().get_parent(), "start_move_selection", [self])
func _unhandled_input(event):
		if Input.is_action_just_pressed("click") and selecting:
			start = mouseposGlobal
			startv = mousepos
			is_dragging = true
		if is_dragging:
			end = mouseposGlobal
			endv = mousepos
			draw_area()
		if Input.is_action_just_released("click") and selecting:
			if startv.distance_to(mousepos) > 20:
				end = mouseposGlobal
				endv = mousepos
				is_dragging = false
				draw_area(false)
				emit_signal("area_selected")
			else:
				end = start
				is_dragging = false
				draw_area(false)
		if Input.is_action_pressed("click") :
			move_to_point = mouseposGlobal
			emit_signal("start_move_selection")
		if event is InputEventScreenTouch:
			if event.pressed:
				events[event.index] = event
			else:
				events.erase(event.index)


func draw_area(s = true):
	rectd.rect_size = Vector2(abs(startv.x-endv.x), abs(startv.y - endv.y))
	var pos = Vector2()
	pos.x = min(startv.x, endv.x)
	pos.y = min(startv.y, endv.y)
	pos.y -= OS.window_size.y
	rectd.rect_position = pos
	
	rectd.rect_size *= int(s) # true = 1 and false = 0



func _input(event):
	#print(OS.window_size, " : " , get_viewport().size)
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
			
	if event is InputEventMouse:
		mousepos = event.global_position - Vector2(0,-450)
		mouseposGlobal = get_global_mouse_position() 
	if not selecting and is_moving:	
		if event is InputEventScreenDrag:
			events[event.index] = event
			if events.size() == 1:
				position -= event.relative * zoom.x
			elif events.size() == 2:
				var drag_distance = events[0].position.distance_to(events[1].position)
				if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
					var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
					new_zoom = clamp(zoom.x * new_zoom, min_zoom, max_zoom)
					zoom = Vector2.ONE * new_zoom
					last_drag_distance = drag_distance
func _on_selecting(val):
	selecting = val

func _on_spawning(val):
	is_moving  = val
