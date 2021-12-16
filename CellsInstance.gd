extends Node

onready var Cells = preload("res://scene/Cells/Cells.tscn")
onready var Health = preload("res://Healthbar.tscn")
var random = RandomNumberGenerator.new()
var screensize = OS.get_screen_size()
var size = 0
var temp = 0
var cells_health_identity = {}
const HEALTH = 100
func spawn_cells(loc):
		var tissue = Cells.instance()
		var health = Health.instance()
		random.randomize()
		var x = random.randf_range(loc.x,screensize.x-1500)
		random.randomize()
		var y = random.randi_range(loc.y,screensize.y)
		tissue.position.x = x
		tissue.position.y = y
		add_child(tissue)
		add_cells_health(tissue.name,HEALTH)
		health.set_position(Vector2(-50,-50))# SET HEALTHBAR COORD
		tissue.add_child(health)
		

func add_cells_health(names,health):
	cells_health_identity[names] = health
	#print(cells_health_identity)
func return_current_cells_health(cells):
	if cells_health_identity.has(cells):
		return cells_health_identity[cells] # return dic value
func return_cells(cells):
	if cells_health_identity.has(cells):
		return cells					# return dic key
func cells_health(its_name,damage):
	if cells_health_identity.has(its_name):	
		cells_health_identity[its_name] = cells_health_identity.get(its_name)-damage
		#print(cells_health_identity.get(its_name) , " : ",damage)
		if  cells_health_identity.get(its_name) <= 0:
			return true
	return false
