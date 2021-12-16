extends Node2D

export var rot_speed = 75
export(int) var cyan_value
export(int) var yellow_value
export(int) var magenta_value
export(int) var purple_value
onready var circle_entity =  get_node(".")

func _ready():
	$Cyan.set_value(cyan_value)
	$Yellow.set_value(yellow_value)
	$Magenta.set_value(magenta_value)
	$Purple.set_value(purple_value)
	for i in range(0,3):
		if self.get_child(i).get_child_count() >= 3:
			self.get_child(i).get_child(2).set_value(cyan_value)


func get_plus():
	for i in range(0,3):
		if self.get_child(i).get_child_count() >= 3:
			var add = self.get_child(i).get_child(2).get_overlapping_bodies()
			for i in add:
				print("NAME: ",i.name)
func _physics_process(_delta):
	circle_entity.rotate(deg2rad(rot_speed * _delta))
	#get_plus()
	
func _on_VisibilityNotifier2D_screen_exited():
	#queue_free()
	pass
