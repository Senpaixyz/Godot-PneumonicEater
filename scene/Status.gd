extends CanvasLayer
onready var sidepanel = get_parent().get_node("Bunker/MenuPress")
func _ready():
	$Star.visible =false
	if global_damage.inprev_level or global_state._load_current_game()["in_prev_level"]:
		if global_damage.get_selected_level() < global_state._load_current_game()["level"][0]:
			$Winner/Continue.hide()
func show_results():
	var inc = 0
	if $Winner.visible == true:
		if $Star.value >= 95 and $Star.value <= 100:
			sidepanel.increased_diamond(10)
			inc = 10
		elif $Star.value >= 85 and $Star.value <= 94:
			sidepanel.increased_diamond(7)
			inc = 7
		elif $Star.value >= 75 and $Star.value <= 84:
			sidepanel.increased_diamond(5)
			inc = 5
		elif $Star.value >= 65 and $Star.value <= 74:
			sidepanel.increased_diamond(3)
			inc = 3
		elif $Star.value >= 55 and $Star.value <= 64:
			sidepanel.increased_diamond(2)
			inc = 2
		else:
			sidepanel.increased_diamond(1)
			inc = 1
	elif $Gameover.visible == true:
		sidepanel.increased_diamond(1)
		inc = 1
	$DiamondAdded.text = str(inc)
func _on_ContinueButton_pressed():
	get_tree().paused=false
	global_damage.get_level()
	global_damage.next_level()
	get_parent().queue_free()
	get_node(".").queue_free()
	get_tree().change_scene("res://scene/GameLevel/Level"+str(global_damage.get_current_level())+".tscn")
	global_damage.is_pressed_location("Ingame")
	global_state.generate_new_save_file(global_damage.get_current_level())


func _on_Restart_pressed():
	get_tree().paused=false
	global_damage.get_level()
	#global_damage.next_level()
	get_parent().queue_free()
	get_node(".").queue_free()
	get_tree().change_scene("res://scene/GameLevel/Level"+str(global_damage.get_current_level())+".tscn")

func _on_Mainmenu_pressed():
	get_tree().paused=false
	global_damage.next_level()
	get_parent().queue_free()
	get_node(".").queue_free()
	get_tree().change_scene("res://scene/MenuScreen/MenuScreen.tscn")

func _on_Quit_pressed():
	get_tree().quit()



