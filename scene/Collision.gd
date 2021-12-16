extends Area2D
var detector_scale = Vector2(0,0)
var counter = 0

func get_coll():
	var bodies = get_overlapping_areas()
	for i in bodies:
		print("NAME: ",i.name)
		
func _on_Time_timeout():
	pass
		#IF DAMAGE? PLAY ANIMATION PLAYER
		#  RAY CAST DETECTION FOR PLAYER
