extends CanvasLayer
signal spawning_mode(val)
const DefaultLoader = preload("res://wave/level_loader.gd")
var waves = []
var wbc_list = []
var position = {}
var wbc
var list_character = []
var start
var goal
onready  var current_node = get_node(".")
var counter = 0
var button_counter = 0
var dragging = false
var colored = true
var adjustment_position = Vector2(-27,20)
onready var get_upperpanel_gold = get_parent().get_parent().get_node("UPPERPANEl")
var loader
var Diamond 
var attribute = {}
#var wbc_dic = {}
var sale_price = {}
var upgrade_price = {}
var damage_level = {}
var health_level = {}
var level_counts = {}
var wbc_temp = {"Neutrophils":0,"Monocytes":0,"Basophils":0,"Eosinophils":0,"Lymphocytes":0}
var maximum = {"Neutrophils":false,"Monocytes":false,"Basophils":false,"Eosinophils":false,"Lymphocytes":false}
var is_on_upgrade = false
func _ready():
	connect("spawning_mode",get_parent().get_parent().get_node("Camera/Camera2D"),"_on_selecting")
	$Counter.hide()
	loader()
	load_attributes()
	set_label()
func loader():
	loader = DefaultLoader.new()
	waves = loader.load_level("player_position")
	position = waves[0]
	start = position["start"]
	goal = position["goal"]
func load_attributes():
	var attribute = null
	var temp = global_state.load_character_attributes()
	sale_price = temp["sale_price"]
	if global_damage.get_location() == "NewGame":
		attribute = global_state.load_character_attributes()
		upgrade_price = attribute["upgrade_price"]
		damage_level = attribute["damage_level"]
		health_level = attribute["health_level"]
		level_counts = attribute["level_counts"]
	elif global_damage.get_location() == "Continue" or global_damage.get_location() == "Ingame":
		var save = global_state._load_current_game()
		attribute = save["current_upgrade"]
		upgrade_price = attribute["list_next_price"]
		damage_level = attribute["list_next_add_damage"]
		health_level = attribute["list_next_add_health"]
		level_counts= attribute["list_level_count"]
		for i in save["upgrade_state"]:
			#upgrade_price[i][0] = save["upgrade_state"][i]["current_price"]
			global_damage.dic_damage[i] = save["upgrade_state"][i]["damage"]
			global_damage.dic_health[i] = save["upgrade_state"][i]["health"]
			wbc_temp[i] = save["upgrade_state"][i]["progress"]      
			maximum[i] = attribute["maximum"][i]
	store_line(
							level_counts,
							upgrade_price,
							damage_level,
							health_level,
							maximum
	)
func _process(delta):
	disabled_wbc()
	if is_on_upgrade:
		$Upgrade/PopupPanel.show()
func set_diamond(val):
	Diamond = val
func update_diamond():
	$Upgrade/PopupPanel/Diamond.text = str(Diamond)
	global_state._get_current_diamond_count(Diamond)
func increased_diamond(val):
	Diamond += val
func decreased_diamond(val):
	Diamond -= val
func set_label():
	$Neutrophils/Price.text = str(sale_price["Neutrophils"])
	$Monocytes/Price.text = str(sale_price["Monocytes"])
	$Basophils/Price.text = str(sale_price["Basophils"])
	$Eosinophils/Price.text = str(sale_price["Eosinophils"])
	$Lymphocytes/Price.text = str(sale_price["Lymphocytes"])
func disabled_wbc():
	var Total_Golds = get_upperpanel_gold.Player_Total_Golds 
	if Total_Golds < sale_price["Neutrophils"]:
		$Neutrophils.disabled = true
	else:
		$Neutrophils.disabled=false
	if Total_Golds < sale_price["Monocytes"]:
		$Monocytes.disabled = true
	else:
		$Monocytes.disabled = false
	if Total_Golds < sale_price["Basophils"]:
		$Basophils.disabled=true
	else:
		$Basophils.disabled =false
	if Total_Golds < sale_price["Eosinophils"]:
		$Eosinophils.disabled=true
	else:
		$Eosinophils.disabled=false
	if Total_Golds < sale_price["Lymphocytes"]:
		$Lymphocytes.disabled=true
	else:
		$Lymphocytes.disabled=false
	
		
func _on_button_up():
	$Timer.stop()

func _on_button_down():
	$Timer.start()	
	$Counter.show()
	
func _on_Timer_timeout():
	counter += 1
	var neu = null
	emit_signal("building_mode",dragging,colored)
	if $Neutrophils.pressed:
		get_upperpanel_gold.decreased_gold(sale_price["Neutrophils"])
		$Counter.rect_position = $Neutrophils.rect_position - adjustment_position
		$Counter.text = str(counter)
		neu = PlayerInstance.spawn_Character("Neutrophils",get_parent().get_node(start).global_position)
		neu.goal = get_parent().get_parent().get_node(goal).global_position- Vector2(30,30)
		neu.nav = get_parent().get_parent().get_node("nav")

		#Bunker/PlayerStart
		#Bunker/Game/InfectedCell/PlayerGoal
	elif $Monocytes.pressed:
		get_upperpanel_gold.decreased_gold(sale_price["Monocytes"])
		$Counter.rect_position = $Monocytes.rect_position - adjustment_position
		$Counter.text = str(counter)
		neu = PlayerInstance.spawn_Character("Monocytes",get_node("../PlayerStart").global_position)
		neu.goal = get_parent().get_parent().get_node("InfectedCell/PlayerGoal").global_position
		neu.nav = get_parent().get_parent().get_node("nav")

	elif $Basophils.pressed:
		get_upperpanel_gold.decreased_gold(sale_price["Basophils"])
		$Counter.text = str(counter)
		neu = PlayerInstance.spawn_Character("Basophils",get_node("../PlayerStart").global_position)
		neu.goal = get_parent().get_parent().get_node("InfectedCell/PlayerGoal").global_position
		neu.nav = get_parent().get_parent().get_node("nav")

	elif $Eosinophils.pressed:
		get_upperpanel_gold.decreased_gold(sale_price["Eosinophils"])
		$Counter.text = str(counter)
		neu = PlayerInstance.spawn_Character("Eosinophils",get_node("../PlayerStart").global_position)
		neu.goal = get_parent().get_parent().get_node("InfectedCell/PlayerGoal").global_position
		neu.nav = get_parent().get_parent().get_node("nav")

	elif $Lymphocytes.pressed:
		get_upperpanel_gold.decreased_gold(sale_price["Lymphocytes"])
		$Counter.text = str(counter)
		neu = PlayerInstance.spawn_Character("Lymphocytes",get_node("../PlayerStart").global_position)
		neu.goal = get_parent().get_parent().get_node("InfectedCell/PlayerGoal").global_position
		neu.nav = get_parent().get_parent().get_node("nav")

	
func _input(event):
	if event is InputEventMouseMotion:
		$Timer.stop()
		emit_signal("spawn_character",list_character)
		$Counter.rect_position = Vector2.ZERO
		$Counter.text = "0"
		$Counter.hide()
		counter = 0


func hide_panel(value):
	for i in get_upperpanel_gold.get_children():
		if value:
			get_upperpanel_gold._hide_panel(true,true)
		else:
			get_upperpanel_gold._hide_panel(false,true)
	for sidepanel in get_node(".").get_children():
		if not sidepanel.name == "Timer":
			if value:
				sidepanel.hide()
			else:
				sidepanel.show()

func _on_Upgrade_pressed():
	$Upgrade/PopupPanel.show()
	hide_panel(true)
	get_tree().paused = true
	is_on_upgrade = true
	update()
func _on_Cancel_pressed():
	$Upgrade/PopupPanel.hide()
	hide_panel(false)
	get_upperpanel_gold.get_node("TowerLIst").visible=false
	get_tree().paused = false
	is_on_upgrade = false
func update():
	update_diamond()
	if not upgrade_price["Neutrophils"].empty():
		$Upgrade/PopupPanel/NeutrophilsText/Details/Price.text = "S "+str(upgrade_price["Neutrophils"][0])
		$Upgrade/PopupPanel/NeutrophilsText/Details/Damage.text = "Damage : " +str(global_damage.dic_damage["Neutrophils"]) + " + " + str(damage_level["Neutrophils"][0])
		$Upgrade/PopupPanel/NeutrophilsText/Details/Health.text = "Health : " +str(global_damage.dic_health["Neutrophils"]) + " + " + str(health_level["Neutrophils"][0])
		$Upgrade/PopupPanel/NeutrophilsText/Details/LevelCount.text = "lvl"+str(level_counts["Neutrophils"][0])
		$Upgrade/PopupPanel/NeutrophilsText/Details/Upgrade.value = wbc_temp["Neutrophils"]
		global_state._get_individual_upgrade("Neutrophils",wbc_temp["Neutrophils"],global_damage.dic_damage["Neutrophils"],global_damage.dic_health["Neutrophils"])
	if not upgrade_price["Monocytes"].empty():
		$Upgrade/PopupPanel/MonocytesText/Details/Price.text = "S "+str(upgrade_price["Monocytes"][0])
		$Upgrade/PopupPanel/MonocytesText/Details/Damage.text = "Damage : " +str(global_damage.dic_damage["Monocytes"]) + " + " + str(damage_level["Monocytes"][0])
		$Upgrade/PopupPanel/MonocytesText/Details/Health.text = "Health : " +str(global_damage.dic_health["Monocytes"]) + " + " + str(health_level["Monocytes"][0])
		$Upgrade/PopupPanel/MonocytesText/Details/LevelCount.text =  "lvl"+str(level_counts["Monocytes"][0])
		$Upgrade/PopupPanel/MonocytesText/Details/Upgrade.value = wbc_temp["Monocytes"]
		global_state._get_individual_upgrade("Monocytes",wbc_temp["Monocytes"],global_damage.dic_damage["Monocytes"],global_damage.dic_health["Monocytes"])
	if not upgrade_price["Basophils"].empty():
		$Upgrade/PopupPanel/BasophilsText/Details/Price.text = "S "+str(upgrade_price["Basophils"][0])
		$Upgrade/PopupPanel/BasophilsText/Details/Damage.text = "Damage : " +str(global_damage.dic_damage["Basophils"]) + " + " + str(damage_level["Basophils"][0])
		$Upgrade/PopupPanel/BasophilsText/Details/Health.text = "Health : " +str(global_damage.dic_health["Basophils"]) + " + " + str(health_level["Basophils"][0])
		$Upgrade/PopupPanel/BasophilsText/Details/LevelCount.text =  "lvl"+str(level_counts["Basophils"][0])
		$Upgrade/PopupPanel/BasophilsText/Details/Upgrade.value = wbc_temp["Basophils"]
		global_state._get_individual_upgrade("Basophils",wbc_temp["Basophils"],global_damage.dic_damage["Basophils"],global_damage.dic_health["Basophils"])
	if not upgrade_price["Eosinophils"].empty():
		$Upgrade/PopupPanel/EosinophilsText/Details/Price.text = "S "+str(upgrade_price["Eosinophils"][0])
		$Upgrade/PopupPanel/EosinophilsText/Details/Damage.text = "Damage : " +str(global_damage.dic_damage["Eosinophils"]) + " + " + str(damage_level["Eosinophils"][0])
		$Upgrade/PopupPanel/EosinophilsText/Details/Health.text = "Health : " +str(global_damage.dic_health["Eosinophils"]) + " + " + str(health_level["Eosinophils"][0])
		$Upgrade/PopupPanel/EosinophilsText/Details/LevelCount.text =  "lvl"+str(level_counts["Eosinophils"][0])
		$Upgrade/PopupPanel/EosinophilsText/Details/Upgrade.value = wbc_temp["Eosinophils"]
		global_state._get_individual_upgrade("Eosinophils",wbc_temp["Eosinophils"],global_damage.dic_damage["Eosinophils"],global_damage.dic_health["Eosinophils"])
	if not upgrade_price["Lymphocytes"].empty():
		$Upgrade/PopupPanel/LymphocytesText/Details/Price.text = "S "+str(upgrade_price["Lymphocytes"][0])
		$Upgrade/PopupPanel/LymphocytesText/Details/Damage.text = "Damage : " +str(global_damage.dic_damage["Lymphocytes"]) + " + " + str(damage_level["Lymphocytes"][0])
		$Upgrade/PopupPanel/LymphocytesText/Details/Health.text = "Health : " +str(global_damage.dic_health["Lymphocytes"]) + " + " + str(health_level["Lymphocytes"][0])
		$Upgrade/PopupPanel/LymphocytesText/Details/LevelCount.text =  "lvl"+str(level_counts["Lymphocytes"][0])
		$Upgrade/PopupPanel/LymphocytesText/Details/Upgrade.value = wbc_temp["Lymphocytes"]
		global_state._get_individual_upgrade("Lymphocytes",wbc_temp["Lymphocytes"],global_damage.dic_damage["Lymphocytes"],global_damage.dic_health["Lymphocytes"])

func _on_UpgradeButton_pressed():
	var temp = ""
	#if $Upgrade/PopupPanel/NeutrophilsText/Details/UpgradeButton.disabled=true
	if $Upgrade/PopupPanel/NeutrophilsText/Details/UpgradeButton.pressed:
		temp = "Neutrophils"
	elif $Upgrade/PopupPanel/MonocytesText/Details/UpgradeButton.pressed:
		temp = "Monocytes"
	elif $Upgrade/PopupPanel/BasophilsText/Details/UpgradeButton.pressed:
		temp = "Basophils"
	elif $Upgrade/PopupPanel/EosinophilsText/Details/UpgradeButton.pressed:
		temp = "Eosinophils"
	elif $Upgrade/PopupPanel/LymphocytesText/Details/UpgradeButton.pressed:
		temp = "Lymphocytes"
	else:
		temp = null
	if not maximum[temp]:
		if Diamond >= upgrade_price[temp][0]:
			decreased_diamond(upgrade_price[temp][0])
			global_damage.dic_damage[temp] += damage_level[temp][0]
			global_damage.dic_health[temp] +=  health_level[temp][0]
			wbc_temp[temp] += 10
			if wbc_temp[temp] >= 100 :
				maximum[temp] = true
				upgrade_price[temp][0] = "MAX"
			else:
				get_node("Upgrade/PopupPanel/"+temp+"Text/Details/Upgrade").value = wbc_temp[temp]
				get_node("Upgrade/PopupPanel/"+temp+"Text/Details/LevelCount").text = "lvl"+str(level_counts[temp][0])
				upgrade_price[temp].pop_front()
				damage_level[temp].pop_front()	
				health_level[temp].pop_front()
				level_counts[temp].pop_front()
			store_line(
							level_counts,
							upgrade_price,
							damage_level,
							health_level,
							maximum
			)
	update()
	update_diamond()
func store_line(level_count,next_price,add_damage,add_health,maximum):
	var general = {
			"list_level_count":level_count,
			"list_next_price":next_price,
			"list_next_add_damage":add_damage,
			"list_next_add_health":add_health,
			"maximum":maximum
		}
	global_state._get_current_upgrade(general)

func spawning():
	emit_signal("spawning_mode",true)
func cancel_spawning():
	print("HELLO")
	emit_signal("spawning_mode",false)
