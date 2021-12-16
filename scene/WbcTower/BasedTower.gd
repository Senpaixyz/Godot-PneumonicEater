extends StaticBody2D
export (int) var detect_radius
export (float) var fire_rate
export (PackedScene) var Bullet
var vis_color = Color(.867, .91, .247, 0.1)
var can_shoot = true
var temp_pos = Vector2()
var waves = []
var wave = {}
var target_node
export var Identity = ""
onready var HUD_UPPERPANEl = get_parent().get_parent().get_node("UPPERPANEl")
onready var TILE_RESET = get_parent().get_parent().get_node("nav/TileMap")
var loader
var attribute = {}
var tower_list 
var tower_upgrade_price = {}
var tower_damage_level = {}
var tower_sell_level  = {}
var tower_level_counts = {}
var counter = 0.0
var target_list = []
var current_tile
var info = {}
func _ready():
	pass
	
func load_attributes():
	attribute = global_state.load_tower_attributes()
	tower_list = attribute["tower_list"]
	tower_upgrade_price = attribute["tower_upgrade_price"]
	tower_damage_level = attribute["tower_damage_level"]
	tower_sell_level = attribute["tower_sell_level"]
	tower_level_counts = attribute["tower_level_counts"]
func load_save(key):
	var dic = global_state._load_level_environment()
	var tower_attributes = dic["current_tower_list"]
	tower_upgrade_price = tower_attributes[key]["global_attribute"]["upgrade_list"]
	tower_damage_level = tower_attributes[key]["global_attribute"]["damage_list"]
	tower_sell_level = tower_attributes[key]["global_attribute"]["sell_list"]
	tower_level_counts = tower_attributes[key]["global_attribute"]["level_counts"]
func _physics_process(delta):
	if target_list.size() > 0:
		target_node = target_list[0]
	if target_node:
			$Sprite.rotation = (target_node.global_position - global_position).angle()
			if can_shoot:
				shoot(target_node.global_position)
	#store_tower_info()
func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	b.start(global_position, a + rand_range(-0.05, 0.05))
	b.set_damage(tower_damage_level[self.get("Identity")][0])
	print("DAMN",tower_damage_level[self.get("Identity")][0])
	get_parent().get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()

func _on_ShootTimer_timeout():
	can_shoot = true
	
func _draw():
	draw_circle(Vector2(), detect_radius, vis_color)

func _on_Range_body_entered(body):
	if body.is_in_group("virus_units"):
		target_list.append(body)
func _on_Range_body_exited(body):
	if body.is_in_group("virus_units"):
		target_list.erase(body)
		target_node = null

func _on_Upgrade_button_down(upgrade_type):
	if HUD_UPPERPANEl.Player_Total_Golds >= tower_upgrade_price[upgrade_type][0]:
		HUD_UPPERPANEl.decreased_gold(tower_upgrade_price[upgrade_type][0])
		tower_damage_level[upgrade_type].pop_front()
		tower_upgrade_price[upgrade_type].pop_front()
		tower_level_counts[upgrade_type].pop_front()
		tower_sell_level[upgrade_type].pop_front()
func _on_Sell_button_down(sell_type):
	HUD_UPPERPANEl.increased_gold(tower_sell_level[sell_type][0])
	self.queue_free()
	current_tile = TILE_RESET.world_to_map(global_position)
	TILE_RESET.set_cellv(current_tile, 2)
func _on_BasedTower_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			$Upgrade.visible = true
			$Sell.visible = true
			$VisibilityTimer.start(counter)
func store_tower_info():
	info = {
			"global_attribute" : {
			"damage_list":tower_damage_level,
			"sell_list":tower_sell_level,
			"level_counts":tower_level_counts,
			"upgrade_list":tower_upgrade_price
			},
			
		}
	return info
func store_tower_upgrade():
	var upgrade = {
			"position_x":self.global_position.x,
			"position_y":self.global_position.y,
			"identity":self.get("Identity")
			
	}
	return upgrade
func _on_VisibilityTimer_timeout():
	counter += 1
	var visibility_limit = 3
	if counter > visibility_limit:
		$Upgrade.visible=false
		$Sell.visible=false
		$VisibilityTimer.stop()
