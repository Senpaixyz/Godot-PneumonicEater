extends Node
var Joystick_touch = false
var Tracking = false
var Level = 0
var wave setget set_wave
var total_waves setget set_total_waves
var neu = "Neutrophils"
var mono = "Monocytes"
var baso = "Basophils"
var eos = "Eosinophils"
var lymp = "Lymphocytes"
var location 
var original_level_list = [1,2,3,4,5]
var level
var selected_level = 0
var inprev_level setget  set_in_prev
var dic_health = {
	neu:100, mono:500,baso:75,eos:120,lymp:200
}
var dic_damage = {
	neu:5,mono:3,baso:15,eos:10,lymp:20
}
func get_level():
	level = global_state._load_current_game()["level"]
func is_pressed_location(val):
	location = val
func get_location():
	return location
func set_wave(w):
	wave = w
func return_wave():
	return wave
func next_level():
	level.pop_front()
func get_current_level():
	#print(get_in_prev() , " : " ,  global_state._load_current_game()["in_prev_level"], global_state._load_current_game()["prev_level"])
	if get_in_prev() :
		return get_selected_level()
	elif global_state._load_current_game()["in_prev_level"]:
		return global_state._load_current_game()["prev_level"]
	else:
		return level[0]
func all_level():
	return level
func selected_level(val):
	selected_level = original_level_list[val]

func get_selected_level():
	return selected_level-1
func set_total_waves(waves):
	total_waves = waves
func get_total_waves():
	return total_waves
func not_touch_joystick():
	if not Joystick_touch:
		return true
	return false
func is_touch(val):
	Joystick_touch = val
func is_enable_tracking():
	return Tracking
func set_in_prev(value):
	inprev_level = value
func get_in_prev():
	return inprev_level
