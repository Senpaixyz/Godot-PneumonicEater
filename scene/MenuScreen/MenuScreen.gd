extends CanvasLayer
var save = {}
var IS_PRESSED = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#global_damage.next_level(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_newgame_pressed():

	get_tree().change_scene("res://scene/GameLevel/Level1.tscn")
	get_node(".").queue_free()
	global_state.generate_new_save_file(global_damage.original_level_list[0])
	global_state.get_data("level",global_damage.original_level_list)
	global_state.get_data("in_prev_level",false)
	global_state._save_current_game()
	global_damage.get_level()
	global_damage.set_in_prev(false)
	global_damage.is_pressed_location("NewGame")

func _on_continue_pressed():
	var current_level = 0
	if global_state._load_current_game()["in_prev_level"]:
		global_damage.get_level()
		current_level = global_state._load_current_game()["prev_level"]
	else:
		global_damage.get_level()
		current_level = global_damage.get_current_level()
	get_tree().change_scene("res://scene/GameLevel/Level"+str(current_level)+".tscn")# LOAD SA CONTINUE IF NEW GAME THEN SAVE
	# HOW ABOUT SELECT AND SAVE ????
	get_node(".").queue_free()
	global_state.generate_new_save_file(current_level)
	global_damage.is_pressed_location("Continue")

func _on_menu_pressed():
	get_tree().change_scene("res://scene/MenuScreen/LevelScreen.tscn")
	get_node(".").queue_free()
