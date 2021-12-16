extends Node
var current = 0
func load_level(val):
	if global_damage.inprev_level:
		current = global_damage.get_selected_level()
	elif global_state._load_current_game()["in_prev_level"]:
		current = global_state._load_current_game()["prev_level"]
	else:
		current =global_damage.get_current_level()
	var file = File.new()
	file.open("res://wave/level"+str(current)+".json", File.READ)
	var d = parse_json(file.get_as_text())
	if not d:
		print("ERROR: Failed to parse wave file")
	return d[val]
	

	
