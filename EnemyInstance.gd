extends Node2D


onready var Virus_1 = preload("res://scene/EnemyScene/Virus1.tscn")
onready var Virus_2 = preload("res://scene/EnemyScene/Virus2.tscn")
onready var Virus_3 = preload("res://scene/EnemyScene/Virus3.tscn")
onready var Virus_4 = preload("res://scene/EnemyScene/Virus4.tscn")
onready var Health = preload("res://Healthbar.tscn")


var random = RandomNumberGenerator.new()
var screensize = OS.get_screen_size()
var size = 0
var temp = 0
var enemy_health = {}
var amount_gold = {}
var HEALTH = 100
func spawn_v1(loc):
		var v1 = Virus_1.instance()
		var health = Health.instance()
		v1.position.x = loc.x
		v1.position.y = loc.y
		get_viewport().get_node("./Level"+str(global_damage.get_current_level())).add_child(v1)
		v1.add_child(health)
		health.set_position(Vector2(-50,-50))# SET HEALTHBAR COORD
		enemy_health_identity(v1.name, HEALTH)
		return v1
func spawn_v2(loc):
	var m = Virus_2.instance()
	var health = Health.instance()
	m.position.x = loc.x
	m.position.y = loc.y
	get_viewport().get_node("./Level"+str(global_damage.get_current_level())).add_child(m)
	m.add_child(health)
	health.set_position(Vector2(-50,-50))# SET HEALTHBAR COORD
	enemy_health_identity(m.name, HEALTH)
	return m
func spawn_v3(loc):
	var b = Virus_3.instance()
	var health = Health.instance()
	b.position.x = loc.x
	b.position.y = loc.y
	get_viewport().get_node("./Level"+str(global_damage.get_current_level())).add_child(b)
	b.add_child(health)
	health.set_position(Vector2(-50,-50))# SET HEALTHBAR COORD
	enemy_health_identity(b.name, HEALTH)
	return b
func spawn_v4(loc):
	var e = Virus_4.instance()
	var health = Health.instance()
	e.position.x = loc.x
	e.position.y = loc.y
	get_viewport().get_node("./Level"+str(global_damage.get_current_level())).add_child(e)
	e.add_child(health)
	health.set_position(Vector2(-50,-50))# SET HEALTHBAR COORD
	enemy_health_identity(e.name, HEALTH)
	return e

	
func enemy_health_identity(key,val):
	enemy_health[key] = val
func return_current_health(enemy_name):
	if enemy_health.has(enemy_name):
		return enemy_health[enemy_name] # return dic value
func return_enemy(enemy_name):
	if enemy_health.has(enemy_name):
		return enemy_name					# return dic key
func enemy_health(its_name,damage):
	if enemy_health.has(its_name):	
		enemy_health[its_name] = enemy_health.get(its_name)-damage
		if  enemy_health.get(its_name) <= 0:
			return true
	return false

