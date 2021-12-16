extends Node2D
signal add_gold(value)
signal switch_on(val)
signal map_moving(val)
const DefaultLoader = preload("res://wave/level_loader.gd")
var Tower1_shaded = preload("res://assets/wbc/neut/pressed.png")
var Tower2_shaded = preload("res://assets/wbc/mono/pressed.png")
var Tower3_shaded = preload("res://assets/wbc/basop/pressed.png")
var Tower4_shaded = preload("res://assets/wbc/eosop/pressed.png")
var Tower5_shaded = preload("res://assets/wbc/lymp/pressed.png")
onready var tilemap = get_node("nav/TileMap")
var shaded_tower = {
	"Tower1":Tower1_shaded,"Tower2":Tower2_shaded,"Tower3":Tower3_shaded,"Tower4":Tower4_shaded,"Tower5":Tower5_shaded
}
var Tower1 = preload("res://scene/WbcTower/NeutrophilsTower.tscn")
var Tower2 = preload("res://scene/WbcTower/MonocytesTower.tscn")
var Tower3 = preload("res://scene/WbcTower/BasophilsTower.tscn")
var Tower4 = preload("res://scene/WbcTower/EosinophilsTower.tscn")
var Tower5 = preload("res://scene/WbcTower/LymphocytesTower.tscn")
#var Tower4 = preload("res://scene/WbcTower/EosinophilsTower.tscn")
#var Tower5 = preload("res://scene/WbcTower/LypocTower.tscn")
var tower_list = {
		"Tower1":Tower1,"Tower2":Tower2,"Tower3":Tower3,"Tower4":Tower4,"Tower5":Tower5
}
var attack_ranges = {	"Tower1" : 5,
						"Tower2" : 4,
						"Tower3" : 8,
						"Tower4" : 15,
						"Tower5" : 35
}

var build_mode = false
var current_tower
var current_tile
var choosen_tower
var can_build = false
var not_on_menu 
var yellow = Color(0.87451, 0.8, 0.094118, 0.576471)
var red = Color(0.87594, 0.092384, 0.092384, 0.576471)
var current_color
export(int)var Level_Count
var player_array = []
onready var Current_Level = get_node(".")
export var Player_Gold = 20000
export var Diamond = 2000
export(int) var Goal_Count
var units = []
var virus_units = []
var selected_units = [] # objects
var selecting = false
var player_aim = []
var enemy_aim = []
var enemy_targeted = {}
var auto_deselect =false
var healthycells = []
var infectedcells = []
var loader 
signal map_update
var tower_list_node
var _load = global_state._load_current_game()
func _ready():
	connect("switch_on",$UPPERPANEl,"switch_on")
	connect("map_moving",get_node("Camera/Camera2D"),"_on_spawning")
	if global_damage.get_location() == "NewGame":
		_loader()
		new_game()
	elif global_damage.get_location() == "Continue":
		_loader()
		continue_game()
	elif global_damage.get_location() == "Ingame":
		_loader()
		in_game()
func _loader():
	loader = DefaultLoader.new()
	waves = loader.load_level("waves")
	Player_Gold = loader.load_level("current_gold")
func new_game():
	this_waves = global_state.load_character_attributes()["wave"]
	$UPPERPANEl.set_player_gold(Player_Gold)
	$Bunker/MenuPress.set_diamond(Diamond)
	$UPPERPANEl.update_player_gold()
	hide_sidepanel(true)
	#waves = global_damage.load_level("waves")
	init_wave(this_waves[0])
	$Status/Star.max_value = _total_star()
	$Status/Star.value = _total_star()
func continue_game():
	if global_state._load_level_environment()["current_tower"] == null:
		this_waves = global_state.load_character_attributes()["wave"]
		$UPPERPANEl.set_player_gold(Player_Gold)
	else:
		this_waves = global_state._load_level_environment()["current_wave"]
		$UPPERPANEl.set_player_gold(global_state._load_level_environment()["current_ingame_gold"])
	_load_attributes()
	$Bunker/MenuPress.set_diamond(_load["current_diamond"])
	hide_sidepanel(true)
	init_wave(this_waves[0])
	$Status/Star.max_value = _total_star()
	$Status/Star.value = _total_star()
func in_game():
	$Bunker/MenuPress.set_diamond(_load["current_diamond"])
	$UPPERPANEl.set_player_gold(Player_Gold)
	hide_sidepanel(true)
	this_waves = global_state.load_character_attributes()["wave"]
	init_wave(this_waves[0])
	$Status/Star.max_value = _total_star()
	$Status/Star.value = _total_star()
func save():
	# ONCE NA NAG RURUN YUNG SAVE FUNCTION YUNG Get in prev set to null bigla
	$Bunker/MenuPress.update()
	get_character_info()
	global_state.get_data("current_diamond",global_state.current_diamond)
	global_state.get_data("current_upgrade",global_state.current_upgrade)
	global_state.get_data("upgrade_state",global_state.upgrade_state)
	global_state.get_data("level",global_damage.all_level())
	global_state.get_data("in_prev_level",global_damage.get_in_prev())
	global_state.get_data("prev_level",global_damage.get_current_level())
	global_state.get_env("current_ingame_gold",return_spawn_gold())
	#global_state.get_env("current_level",global_damage.get_current_level())
	#global_state.get_env("select_level",global_damage.select_level())
	global_state.get_env("current_wave",this_waves)
	global_state.get_env("current_tower_list",global_state.current_tower_list)
	global_state.get_env("healthy_cell_status",global_state.healthy_cell_status)
	global_state.get_env("infected_cell_status",global_state.infected_cell_status)
	global_state.get_env("list_wbc_spawn",global_state.list_wbc_spawn)
	global_state.get_env("current_tower",global_state.current_tower)
	global_state.get_env("list_viruses_spawn",global_state.list_viruses_spawn)
	global_state._save_current_game()
	global_state._save_environment()
func _load_attributes(): # AFTER THE BATTLE FINISH WERE MUST DELETE THE SAVE DATA
	var dic = {}
	dic = global_state._load_level_environment()
	if dic["current_tower"] == null: # THE HIGHGEST LEVEL SCORe SHOULd Not be resetted..eg global_damage.get_current_level()
		return
	var tower_attributes = dic["current_tower"]
	#Build Tower
	for size in tower_attributes:
		var new_tower = tower_list[tower_attributes[size]["identity"]].instance()
		var current_tile = tilemap.world_to_map(Vector2(tower_attributes[size]["position_x"],tower_attributes[size]["position_y"]))
		new_tower.add_to_group("tower_list_node")
		new_tower.position = tilemap.map_to_world(current_tile)
		tilemap.set_cellv(current_tile, 4)
		new_tower.load_save(size)
		$WBCTower.add_child(new_tower)
	#GET THE INFECTED CELL CURRENT HEALTH
func return_spawn_gold():
	var temp_price = 0
	var character_price_list = global_state.load_character_attributes()["sale_price"]
	for i in units:
		temp_price += character_price_list[i.get("self_tag")]# KELANGAN NATEN MA BALIK UNG PERA SARECENT WAVE MEANING EVERY WAVE DEYM
	return temp_price+$UPPERPANEl.get_player_gold()
func _total_star():
	var tmp = 0
	for cell in get_tree().get_nodes_in_group("healthycell"):
		tmp += cell.Health
	return tmp
func _process(delta):
	update()
	units = get_tree().get_nodes_in_group("units")
	virus_units = get_tree().get_nodes_in_group("virus_units")
	healthycells = get_tree().get_nodes_in_group("healthycell")
	infectedcells = get_tree().get_nodes_in_group("infectedcells")
	tower_list_node = get_tree().get_nodes_in_group("tower_list_node")
	wave_runner(delta)
func get_character_info():
	for unit in units:
		global_state._get_wbc_count_in_game(unit.name,PlayerInstance.return_current_health(unit.name),unit.global_position)
	for virus in virus_units:
		global_state._get_enemy_count_in_game(virus.name,EnemyInstance.return_current_health(virus.name),virus.global_position)
	for h_cell in healthycells:
		global_state.get_healthycell_health_status(h_cell.name,h_cell.Health)
	for i_cell in infectedcells:
		global_state.get_infectedcell_health_status(i_cell.name,i_cell.Health)
	for tower in tower_list_node:
		global_state._get_current_tower_count(tower.name,tower.store_tower_info())
		global_state._get_individual_tower_upgrade(tower.name,tower.store_tower_upgrade())
func _input(event):
		if event is InputEventMouseMotion and build_mode:
			update_builder()
		if current_tile != null:
			if Input.is_action_just_released("click") and build_mode:
				if tilemap.get_cellv(current_tile) != 2 or current_color == red and not_on_menu:
					build_mode= false
					$BuildMode.hide()
					$BuildMode.global_position = Vector2(-500,-500)
					emit_signal("map_moving",true)
				else:
					_update_tower_cost()
					_update_build_tower()
					
func _update_tower_cost():
	if choosen_tower == "Tower1":
		$UPPERPANEl.decreased_gold($UPPERPANEl.tower_price["t1"])
	elif choosen_tower  == "Tower2":
		$UPPERPANEl.decreased_gold($UPPERPANEl.tower_price["t2"])
	elif choosen_tower  == "Tower3":
		$UPPERPANEl.decreased_gold($UPPERPANEl.tower_price["t3"])
	elif choosen_tower  == "Tower4":
		$UPPERPANEl.decreased_gold($UPPERPANEl.tower_price["t4"])
	elif choosen_tower  == "Tower5":
		$UPPERPANEl.decreased_gold($UPPERPANEl.tower_price["t5"])
func update_builder():
	var mouse_position = get_global_mouse_position()
	current_tile = tilemap.world_to_map(mouse_position)
	$BuildMode.position = tilemap.map_to_world(current_tile)
	if tilemap.get_cellv(current_tile) == 2 and current_color != yellow:
		current_color = yellow
		can_build = true
		$BuildMode/TemporarySprite.material.set_shader_param("current_color", current_color)
		#$BuildMode/PolyRange.color = current_color
	if tilemap.get_cellv(current_tile) != 2 and current_color != red:
		current_color = red
		can_build = false
		$BuildMode/TemporarySprite.material.set_shader_param("current_color", current_color)
		#$BuildMode/PolyRange.color = current_color
func _update_build_tower():
	if can_build :
		tilemap.set_cellv(current_tile, 4)
		var new_tower = current_tower.instance()
		new_tower.add_to_group("tower_list_node")
		new_tower.position = tilemap.map_to_world(current_tile)
		new_tower.load_attributes()
		$WBCTower.add_child(new_tower)
		build_mode= false
		$BuildMode.hide()
		$BuildMode.global_position = Vector2(-500,-500)
		emit_signal("map_moving",true)
func is_in_menu(val):
	not_on_menu = val
var waves = []
var price = {}
var wave = {}
var added_gold = {}
var idx = 0
var wave_idx = 0
const WAIT = 0
const ACTIVE = 1
const FINISHED = 2
var playing_wait
var playing_active
var playing_finished
var start_countdown = 0
var spawn_time = 0
var time =0
var level = 1
var victory= false
var panel_not_show = true
var PLAYER_BASED_DESTROY = false
var ENEMY_BASED_DESTROY = false
var destroy = false
var enemy_goal_list = ["goal","goal2","goal3","goal4"]
var TotalCell = 0
var this_waves = []
func init_wave(indx):
	wave_idx = indx
	global_damage.set_wave(indx)
	global_damage.set_total_waves(waves.size())
	wave = waves[indx]
	wave["count"] = wave["enemies"].size()
	wave["state"] = WAIT
	wave["idx"] = 0
	added_gold = wave["added_gold"]
	start_countdown = wave["intval"]
func start_wave():
	wave["state"] = ACTIVE
	#get_node("WaveSprite/WaveLabel").set_text(str(wave_idx+1) + "/" + str(waves.size()))
	spawn_time = time + wave["enemies"][wave["idx"]]["intval"]
	$UPPERPANEl/UpperPanel/CenterContainer/WavesCount.text = str(wave_idx+1) + "/" + str(waves.size())
func match_instances(ins_name,start,goal):
	var level_start = get_node(start).global_position
	var level_goal = get_node(goal).global_position
	var virus = null
	match ins_name:
		"Virus1":
			virus = EnemyInstance.spawn_v1(level_start)
		"Virus2":
			virus = EnemyInstance.spawn_v2(level_start)
		"Virus3":
			virus = EnemyInstance.spawn_v3(level_start)
		"Virus4":
			virus = EnemyInstance.spawn_v4(level_start)
		"Virus5":
			virus = EnemyInstance.spawn_v5(level_start)
	virus.goal = level_goal
	virus.nav = get_node("nav")
	connect("map_update",virus,"update_path")
	virus.add_to_group("virus_units")

	
func update_goal(boolean):
	if boolean:
		var enemy = wave["enemies"][wave["idx"]]
		var goal = enemy[enemy_goal_list[0]]
		var level_goal = get_node(goal).global_position
		for i in virus_units:
			i.goal = level_goal
			i.nav = get_node("nav")
			i.update_path()
	destroy = false
	
	
var temp_waves = []
func temp_wave():
	if temp_waves.size() <= 1:
		for i in 2:
			temp_waves.append(this_waves[i+1])
		this_waves.pop_front()
func wave_runner(delta):
	time += delta
	if wave["state"] == ACTIVE:
		if wave["idx"] < wave["count"]:
			if time > spawn_time:
				var enemy = wave["enemies"][wave["idx"]]
				var path = null
				path = enemy[enemy_goal_list[0]]
				if path == null:
					PLAYER_BASED_DESTROY=true
				else:
					match_instances(enemy["type"],enemy["start"],path)
					#update_goal(destroy)
					if (wave["idx"]+1) < wave["count"]:
						# Next enemy in wave
						wave["idx"] += 1
						spawn_time = time + wave["enemies"][wave["idx"]]["intval"]
					else:
						wave["state"] = FINISHED
						if (wave_idx+1) < waves.size():
							temp_wave()
							init_wave(temp_waves.pop_front())
			else:
				pass
		else:
			pass
	elif wave["state"] == WAIT:
		start_countdown -= delta
		if start_countdown > 0:
			pass
		else:
			save()
			start_wave()
	if wave["state"] == FINISHED and virus_units.size() == 0 and ENEMY_BASED_DESTROY:
		$Status/Winner.visible=true
		get_tree().paused = true
		$Status/Bg.visible=true
		$Status/Star.visible =true
		$Status/DiamondAdded.visible = true
		$Status.show_results()
		global_state._delete_level_environment()
	elif PLAYER_BASED_DESTROY:
		$Status/Gameover.visible = true
		get_tree().paused = true
		$Status/DiamondAdded.visible = true
		$Status/Bg.visible=true
		$Status.show_results()
		global_state._delete_level_environment()
	else:
		update_goal(destroy)

func hide_sidepanel(hide):
	for child in $Bunker/MenuPress.get_children():
		if child.name == "Timer":
			pass
		else:
			if hide:
				child.hide()
			else:
				child.show()
				
func _on_Bunker_pressed():
	if panel_not_show:
		hide_sidepanel(panel_not_show)
		$UPPERPANEl/TowerLIst.hide()
		$Bunker/Cancel.show()
		panel_not_show = false
		build_mode = false
		$BuildMode.hide()
	else:
		hide_sidepanel(panel_not_show)
		panel_not_show = true
func _on_Cancel_button_down():
	print("BUNKER CANCEL")
	$Bunker/Cancel.visible = false
	$UPPERPANEl/TowerLIst.show()
	hide_sidepanel(panel_not_show)
	panel_not_show = true
func hit(damage,target):
	if healthycells.has(target):
		for cell in healthycells:
			if cell == target:
				cell.damage_cells(damage)
				$Status/Star.value -= damage
				global_state.get_healthycell_health_status(cell,cell.Health)
				if cell.current_health() <= 0:
					enemy_goal_list.erase(cell)
					destroy = true
					healthycells.erase(cell)
					cell.queue_free()
					if healthycells.size() == 0:
						PLAYER_BASED_DESTROY = true

	if infectedcells.has(target):
			for cell in infectedcells:
				if cell == target:
					cell.damage_cells(damage)
					global_state.get_infectedcell_health_status(cell,cell.Health)
					if cell.Health <= 0:
						infectedcells.erase(cell)
						cell.queue_free()
						if infectedcells.size() == 0:
							ENEMY_BASED_DESTROY = true		
	if units.has(target):	# VIRUS to PLAYER
		for unit in units:
			if unit == target:
				var health = unit.get_node("Healthbar")
				health._on_health_updated(PlayerInstance.return_current_health(unit.name),damage)
				if 	PlayerInstance.player_health(unit.name,damage):
					deselect_unit(unit)
					unit.queue_free()
	if virus_units.has(target): # PLAYER TO VIRUS
		for virus_unit in virus_units:
			if virus_unit == target:
				var health = virus_unit.get_node("Healthbar")

				health._on_health_updated(EnemyInstance.return_current_health(virus_unit.name),damage)
				if EnemyInstance.enemy_health(virus_unit.name,damage):
					var gold = added_gold[virus_unit.get("Identity")]
					emit_signal("add_gold",gold)
					deselect_unit(virus_unit)
					virus_unit.queue_free()
		connect("add_gold",get_node("UPPERPANEl"),"increased_gold")

func _on_Timer_timeout():
	$UPPERPANEl.update_player_gold()

	
func select_unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
#ILISTA ANG SELECTED UNIT AND DELETE THOSE UNIT THAT IS DEAD
func deselect_unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)

func deselect_all():
	while selected_units.size() > 0:
		selected_units[0].set_selected(false)


func was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break
func deselect_pressed(val):
	deselect_all()
func get_units_in_area(area):
	var u = []
	for unit in units:
		if unit.position.x > area[0].x and unit.position.x < area[1].x:
			if unit.position.y > area[0].y and unit.position.y < area[1].y:
				u.append(unit)
				
	return u

func area_selected(obj):
	var start = obj.start
	var end = obj.end
	var area = []
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	var ut = get_units_in_area(area)
	for u in ut:
		u.selected = not u.selected
func remove_died_units(unit_name):
	deselect_unit(unit_name)
func start_move_selection(obj):
	if selected_units.size() == 1:
		selected_units[0].move_unit(obj.move_to_point)
		$UPPERPANEl/UpperPanel/CenterContainer6/CheckButton.pressed = true
		emit_signal("switch_on",true)
	else:
		for un in selected_units:
				un.move_unit(obj.move_to_point)
var counter=0
var wall_list = []
var is_on_wall = []
func get_wall_list():
	for timer in $nav/WallTimer.get_children():
		wall_list.append(timer)
	wall_list.shuffle()
	randomize()
	return wall_list[randi() % $nav/WallTimer.get_child_count()]
func _on_WallTimer_timeout():
	counter += 1
	var walls = $nav/WallTimer.get_children()
	if not walls.empty():
			var tile = $nav/TileMap.world_to_map(get_wall_list().position)
			match counter:
				3:
					$nav/TileMap.set_cell(tile.x,tile.y,3)
				5:	
					$nav/TileMap.set_cell(tile.x,tile.y,0)
				7:
					$nav/TileMap.set_cell(tile.x,tile.y,3)
				10:
					$nav/TileMap.set_cell(tile.x,tile.y,0)
			if counter >= 15:
				counter = 0
				print("REACH")
				#$nav/TileMap.set_cell(is_on_wall[0].x,is_on_wall[0].y,0)
				#is_on_wall.pop_front()
			emit_signal("map_update")

func _build_shader(tower):
		current_tower = tower_list[tower]
		choosen_tower = tower
		$BuildMode/TemporarySprite.texture = shaded_tower[tower]
		$BuildMode/TemporarySprite.scale = Vector2(0.06,0.07)
		#$BuildMode/PolyRange.polygon = get_attack_range_shape(attack_ranges[tower])
		build_mode = true
		$BuildMode.show()
		emit_signal("map_moving",false)
	




