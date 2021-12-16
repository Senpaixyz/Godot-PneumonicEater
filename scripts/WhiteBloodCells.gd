extends KinematicBody2D


const DISTANCE_THRESHOLD = 40

var counter = -2

###########DEBUG#######################3
var tag = "Enemy"
var speed = 70
var nav = null setget set_nav
var list_path = []
var goal = Vector2()
var enemy_position = Vector2.ZERO
var target
var last_node = null
var rotation_value=0
func _ready():
	set_process(true)
	#$Detector/Sprite.self_modulate = Color(0.2, 0, 0)
	var shape = CircleShape2D.new()
	shape.radius = detect_radius
	$Detector/CollisionShape2D.shape = shape
	$ShootTimer.wait_time = fire_rate
	waves = global_state.load_level("waves")
func set_nav(new_nav):
	nav = new_nav
	update_path()

func update_path():
	list_path = nav.get_simple_path(global_position, goal, false)
	if list_path.size() <= 2:
		pass
func _physics_process(delta):
		if list_path.size() > 0 and not target:
			var d = position.distance_to(list_path[0])
			if d > 2:
				position = position.linear_interpolate(list_path[0],(speed*delta)/d)
				rotation_value = (list_path[0] - position).angle()
			else:
				list_path.remove(0)
		if target:
			rotation = (target.global_position - global_position).angle()

			if can_shoot:
				shoot(target.global_position)
				update_path()
		print(rotation_value)
		if rotation_value > 0:
			$Detector/Sprite.animation = "left"
		if rotation_value < 0:
			$Detector/Sprite.animation = "right"

	#if velocity.x != 0:
	#	$AnimatedSprite.animation = "right"
#		$AnimatedSprite.flip_v = false
	#	$AnimatedSprite.flip_h = velocity.x < 0
	#elif velocity.y != 0:
	#	$AnimatedSprite.animation = "up"
	#	$AnimatedSprite.flip_v = velocity.y > 0

export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var can_shoot = true
var temp_pos = Vector2()
var waves = []
var wave = {}
export var Identity = ""
func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	b.set_damage(enemy_shoot_damage(0))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()
func enemy_shoot_damage(val):
	var indx = global_damage.wave
	wave = waves[indx]
	var damage = wave["damage"]
	print(damage)
	if val == 0:
		
		if damage.has(Identity):
			damage[Identity] -= val
			return damage[Identity]
	else:

		damage[Identity]+=val
		return damage[Identity]
func _on_ShootTimer_timeout():
	can_shoot = true
	
func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)

func _on_Detector_area_entered(area):
	pass
		
func _on_Detector_area_exited(area):
	pass

func _on_Range_timeout():
	counter += 0.5
	$Detector/CollisionShape2D.scale = Vector2(counter,counter)
	if counter > 8:
		counter = 0


func _on_Detector_body_entered(body):
	if target:
			return
	if body.get("tag") == "Player":
		target = body
	var temp = "HealthyCellD"
	var compare = (body.name).substr(0,temp.length()-1)
	if compare == "HealthyCell":
		target = body


func _on_Detector_body_exited(body):
	if body.get("tag") == "Player":
		update_path()
		target = null
	var temp = "HealthyCellD"
	var compare = (body.name).substr(0,temp.length()-1)
	if compare == "HealthyCell":
		target = null
