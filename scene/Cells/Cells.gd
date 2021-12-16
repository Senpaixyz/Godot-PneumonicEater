extends KinematicBody2D

export var Health_Tag = ""
var Health=0
var base = "HealthyCellD"
var count = 0
var cell = {}
var waves = {}
func _ready():
	$Healthbar.visible=false
	waves = global_state.load_level("cell_health")
	cell = waves[0]
	Health = cell[Health_Tag]
	$Healthbar._on_max_health_updated(Health)
	
func damage_cells(damage):
	Health -= damage
	print(Health, " : " , damage)
	$Healthbar._on_health_updated(Health,damage)
func current_health():
	return Health

func signal_node():
	var substr = (self.name).substr(0,base.length()-1)
	if substr == "HealthyCell":
		return 0
	elif self.name == "InfectedCell":
		return 1


func _on_Update_timeout():
	count += 1
	$Cells/CollisionShape2D.scale = Vector2(count,count)
	if count > 5:
		count = -2


func _on_Cells_input_event(viewport, event, shape_idx):
	$Healthbar.visible=true


func _on_Cells_mouse_exited():
	$Healthbar.visible=false
	
