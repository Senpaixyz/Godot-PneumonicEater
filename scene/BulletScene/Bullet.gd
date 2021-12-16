extends Area2D
signal hit(d,b,s)
var speed = 1000
var velocity = Vector2()
var damage = null

func _ready():
	connect("hit",get_parent(),"hit")
func start(pos, dir):
	position = pos
	rotation = dir
	velocity = Vector2(speed, 0).rotated(dir)
func set_damage(damage):
	self.damage = damage
func _physics_process(delta):
	global_position += velocity * delta
	
func _on_Bullet_body_entered(body):
	if body == null:
		body = null
	else:
		emit_signal("hit",self.damage,body)	
		queue_free()
