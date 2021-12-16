extends Node2D


onready var Player = preload("res://scene/Player.tscn")
onready var Neutrophils_instance = preload("res://scene/PlayerCharacter/Neutrophils.tscn")
onready var Monocytes_instance = preload("res://scene/PlayerCharacter/Monocytes.tscn")
onready var Basophils_instance = preload("res://scene/PlayerCharacter/Basophils.tscn")
onready var Eosinophils_instance = preload("res://scene/PlayerCharacter/Eosinophils.tscn")
onready var Lymphocytes_instance = preload("res://scene/PlayerCharacter/Lymphocytes.tscn")
onready var Health = preload("res://Healthbar.tscn")


var counter = 0
var current_position = Vector2()
var Total_Instances  = 0
var player_health = {}
func _ready():
	pass
func spawn_Player(node=null,original_pos=null,val=null,overlapping_bodies=null):
	#update()
	var player = Player.instance()
	var health = Health.instance()
	if node != null and original_pos != null:
		player.position = original_pos + Vector2(45,45)
		add_child(player)
	elif val != null:
		if overlapping_bodies.size() > 0:
			player.position = val.position
		add_child(player)
	health.set_position(Vector2(-50,-50))# SET HEALTHBAR COORD
	player.add_child(health)
	#player_health_identity(player.name, HEALTH)
func spawn_Character(val,original_pos):
	var wbc = null
	var string = ""
	var health = Health.instance()
	match val:
		global_damage.neu:
			wbc = Neutrophils_instance.instance()
			string = global_damage.neu
		global_damage.mono:
			wbc = Monocytes_instance.instance()
			string = global_damage.mono
		global_damage.baso:
			wbc = Basophils_instance.instance()
			string = global_damage.baso
		global_damage.eos:
			wbc = Eosinophils_instance.instance()
			string = global_damage.eos
		global_damage.lymp:
			wbc = Lymphocytes_instance.instance()
			string = global_damage.lymp
		global_damage.eos:
			wbc = Eosinophils_instance.instance()
			string = global_damage.eos
		global_damage.lymp:
			wbc = Lymphocytes_instance.instance()
			string = global_damage.lymp
	wbc.position = original_pos + Vector2(randi()%45,randi() % 45)
	get_viewport().get_node("./Level"+str(global_damage.get_current_level())).add_child(wbc)
	wbc.add_child(health)
	wbc.get_node("Healthbar").visible = false
	health.set_position(Vector2(-50,-50))# SET HEALTHBAR COORD
	wbc.add_to_group("units")
	player_health_identity(wbc.name, global_damage.dic_health[string])
	counter += 1
	return wbc
func player_health_identity(key,val):
	player_health[key] = val

func return_current_health(player_name):
	if player_health.has(player_name):
		return player_health[player_name] # return dic value
func return_player(player_name):
	if player_health.has(player_name):
		return player_name					# return dic key
func player_health(its_name,damage):
	if player_health.has(its_name):	
		player_health[its_name] = player_health.get(its_name)-damage
		if  player_health.get(its_name) <= 0:
			return true
	return false

