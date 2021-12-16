extends Node
var save_file = ""
var save_info = {}
var environment_data = {}
var healthy_cell_status = {}
var infected_cell_status = {}
var	list_wbc_spawn = {}
var list_viruses_spawn = {}
var current_level = {}
var level 
var wave_count
var current_diamond
var current_upgrade = {}
var current_tower_list = {}
var upgrade_state = {}
var current_tower = {}
func _save_current_game(): # CAN BE REPLACE BY NEW UPDATE OR CAN BE OVERWRITE
	var l = current_level
	var save = File.new()
	save.open("res://save/save.save",File.WRITE)
	save.store_line(to_json(l))
	save.close()
func _load_current_game():
	var save = File.new()
	save.open("res://save/save.save",File.READ)
	var current_line = parse_json(save.get_as_text())
	save_info = current_line
	save.close()
	return save_info
	# CALL THE SAVE ENVIRONMENT IN EVERY LAST WAVE OF THE GAME
func _save_environment(): 	# CAN BE CHANGE BY THE ENVIRONTMENT
	var d = environment_data
	var save_env = File.new()
	save_env.open("res://save/"+save_file+".save",File.WRITE)
	save_env.store_line(to_json(d))
	save_env.close()
#LOAD ENVIRONMENT
func _load_level_environment():
	var save_env = File.new()
	var info = {}
	if not save_env.file_exists("res://save/"+save_file+".save"):
		print("HELLO",save_file)
		return 
	save_env.open("res://save/"+save_file+".save",File.READ)
	var data = parse_json(save_env.get_as_text())
	info = data
	return info
#LOAD LEVEL
func load_level(val):
	var file = File.new()
	#var load_current_wave = load_character_attributes()
	file.open("res://wave/level"+str(global_damage.get_current_level())+".json", File.READ) # eg. level-01-waves.json
	var txt = file.get_as_text()
	var d = parse_json(txt)
	if not d:
		print("ERROR: Failed to parse wave file")
	return d[val]
	file.close()
func load_character_attributes():
	var file = File.new()
	file.open("res://wave/characterattributes.json", File.READ)
	var tmp = file.get_as_text()
	var t = parse_json(tmp)
	if not t:
		print("INVALID: Failed to open file.")
	return t
	file.close()
func load_tower_attributes():
	var file = File.new()
	file.open("res://wave/towerattributes.json",File.READ)
	var tmp = file.get_as_text()
	var tower = parse_json(tmp)
	if not tower:
		print("Couldn't Load tower data.")
	return tower
	file.close()
func _delete_level_environment():
	var save_env = File.new()
	if not save_env.file_exists("res://save/"+save_file+".save"):
		return
	save_env.open("res://save/"+save_file+".save",File.WRITE)
	var empty = {"current_tower":null}
	save_env.store_line(to_json(empty)) # DAPAT MAG INCREMENT YUN SAVE_FILE + 1 KADA LEVEL DONE
	save_env.close()
	

func generate_new_save_file(index):
	save_file = "temp_save"+str(index)

func get_data(key,value):
	current_level[key] = value
func get_env(key,value):
	environment_data[key] = value

func _get_current_diamond_count(val):
	current_diamond = val
func _get_current_upgrade(data):
	current_upgrade = data
func _get_individual_upgrade(id_name,progress,damage,health):
	upgrade_state[id_name] = {
		"progress":progress,
		"damage":damage,
		"health":health
	}


func get_infectedcell_health_status(id_name,status):
	infected_cell_status[id_name]  = status
func get_healthycell_health_status(id_name,status):
	healthy_cell_status[id_name] = status

func _get_wbc_count_in_game(id_name,status,position):
		var temp = {
			"status" :status,
			"position":position
		}
		list_wbc_spawn[id_name] = temp
func _get_enemy_count_in_game(id_name,status,position):
		var temp = {
			"status" :status,
			"position":position
		}
		list_viruses_spawn[id_name] = temp
func _get_current_tower_count(val,info):
	current_tower_list[val] = info
func _get_individual_tower_upgrade(names,data):
	current_tower[names] = data
