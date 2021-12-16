extends KinematicBody2D


export var speed = 130
var Level = preload("res://scene/Main.gd")
var selected = false setget set_selected
var target_list = []
var targeted_list = []
var move_p = false
var to_move = Vector2()
var path = PoolVector2Array()
var initialposition = Vector2()
var obj = Vector2.ZERO
var events = {}
var targeted  = false
var target_node
signal was_selected
signal was_deselected
signal was_killed
signal target
#########################
var tag = "Player"
var nav = null setget set_nav
var list_path = []
var goal = Vector2()
var enemy_position = Vector2.ZERO
var into_point = false
var wait = false
var count  = 0
export var self_tag = ""
func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	list_path = nav.get_simple_path(global_position, goal, false)
	if list_path.size() == 0:
		queue_free()

func set_selected(value):
	if selected != value:
		selected = value
		$Healthbar.visible = value
		into_point = selected
		if selected:
			emit_signal("was_selected", self)
		else:
			emit_signal("was_deselected", self)

func _ready():
	connect("was_selected", get_parent(), "select_unit")
	connect("was_deselected", get_parent(), "deselect_unit")
	connect("target",get_parent(),"target")
	#$Sprite.self_modulate = Color(0.2, 0, 0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	#$Visibility/Attack.shape = shape
	$ShootTimer.wait_time = fire_rate
func _physics_process(delta):
		update()
		if move_p:
			path = get_viewport().get_node("Level"+str(global_damage.get_current_level())+"/nav").get_simple_path(global_position, to_move+Vector2(randi()%100, randi()%100))
			initialposition = global_position
			move_p = false
		if path.size() > 0:
			move_towards(initialposition, path[0], delta)
			wait = true
		elif not wait:
			if (list_path.size() > 1 and not target_node) and ( list_path.size() > 1 and not into_point) :
				var d = position.distance_to(list_path[0])
				if d > 2:
					position = position.linear_interpolate(list_path[0],(speed*delta)/d)
				else:
					list_path.remove(0)
		if target_node:
			rotation = (target_node.global_position - global_position).angle()
			if can_shoot:
				shoot(target_node.global_position)
func move_towards(pos, point, delta):
	var v = (point - pos).normalized()
	v *= delta * speed
	global_position += v
	if global_position.distance_squared_to(point) < 9:
		path.remove(0)
		initialposition = global_position
		into_point = false
		
func move_unit(point):
	to_move = point
	move_p = true
	wait = true


signal on(val)
func _on_Player_input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		set_selected(not selected)
		emit_signal("on",true)
	connect("on",get_parent(),"on_select_off")
	connect("on",get_parent().get_node("Camera/Camera2D"),"on_select_off")

func _on_EnemyDetector_body_entered(body):

	if target_node:
		return
	if body.get("tag") == "Enemy":
		target_node = body
	var temp = (body.name).substr(0,13-1)
	if temp == "InfectedCell":
		target_node = body

func _on_EnemyDetector_body_exited(body):
	if	body  == target_node:
		target_node = null
		update_path()


###DEBUGGING##########\
export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var can_shoot = true

func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	b.set_damage(set_wbc_damage(self))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()
	
	
func set_wbc_damage(value):
		match value.get("self_tag"):
			"Neutrophils":
				return global_damage.dic_damage["Neutrophils"]
			"Monocytes":
				return global_damage.dic_damage["Monocytes"]
			"Basophils":
				return global_damage.dic_damage["Basophils"]
			"Eosinophils":
				return global_damage.dic_damage["Eosinophils"]
			"Lymphocytes":
				return global_damage.dic_damage["Lymphocytes"]
func _on_ShootTimer_timeout():
	can_shoot = true
	
func _draw():
	pass
	#draw_circle(Vector2(), detect_radius, vis_color)

func _on_Range_timeout():
	count += 1
	$EnemyDetector/CollisionShape2D.scale = Vector2(count,count)
	if count > 3:
		count = -2
