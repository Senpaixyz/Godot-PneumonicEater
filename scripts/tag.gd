extends Area2D

export var Tag = ""
export(int) var Num
func _physics_process(delta):
	pass
	#var bodies = get_overlapping_bodies()
	#print(bodies)
	#print(i.name)


func set_value(val):
	Num = val
func get_value():
	return Num

	
