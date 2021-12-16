extends CanvasLayer
var _load = global_state._load_current_game()
var temp = ""
var c  = 0
signal current_wave(val)

func _ready():
	if _load["level"][0] >= 2:
		$Level2.disabled=false
		$lvl2.visible=true
	if  _load["level"][0] >= 3:
		$Level3.visible=false
		$lvl3.disabled = true
	if  _load["level"][0] >= 4:
		$Level4.disabled=false
		$lvl4.visible=true
	if  _load["level"][0]  >= 5:
		$Level5.disabled=false
		$lvl5.visible=true
func _pressed(level,count):
	match level:
		"Level1":
			temp = level
			c = count
		"Level2":
			temp = level
			c = count
		"Level3":
			temp = level
			c = count
		"Level4":
			temp = level
			c = count
		"Level5":
			temp = level
			c = count
	get_tree().change_scene("res://scene/GameLevel/"+temp+".tscn")
	#if global_state.load_character_attributes()["in_prev_level"]:
	global_damage.selected_level(c)
	global_state.generate_new_save_file(c)
	global_damage.get_level()
	#global_state._save_current_game()
	_is_in_prev()
	get_node(".").queue_free()
	global_damage.is_pressed_location("Continue")
	
func _is_in_prev():
	if c == global_state._load_current_game()["level"][0]:
		global_damage.set_in_prev(false)
		global_state.get_data("in_prev_level",false)
	else:
		global_damage.set_in_prev(true)
		global_state.get_data("in_prev_level",true)
