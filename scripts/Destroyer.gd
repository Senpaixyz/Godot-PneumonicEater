extends Area2D

export(int) var D_index 
func _physics_process(delta):
	
	var bodies = get_overlapping_areas()
	for i in bodies:
		pass
