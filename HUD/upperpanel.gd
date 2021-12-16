extends CanvasLayer
signal enable_tracking(val)
signal deselect(val)
signal selecting(val)
signal building_mode(val)
signal on_menu(val)
var Player_Total_Golds setget set_player_gold
var current_gold 
onready var Pop_up_menu = get_node("PopUp")
var tracking = false
var selecting = false
var in_menu = false
var can_build = false
var tower_price = {
	"t1": 5, "t2": 7, "t3":8,"t4":10,"t5":20
}
func _ready():
	Pop_up_menu.visible = false
	connect("selecting",get_parent().get_node("Camera/Camera2D"),"_on_selecting")
	connect("deselect",get_parent(),"deselect_pressed")
	connect("building_mode",get_parent(),"_build_shader")
	connect("on_menu",get_parent(),"is_in_menu")
	$Level/Label.text = str(global_damage.get_current_level())
	set_label()
func _process(delta):
	disabled_tower()
func set_player_gold(this_gold):
	Player_Total_Golds = this_gold
	update_player_gold()
func get_player_gold():
	return Player_Total_Golds
func update_player_gold():
	$UpperPanel/CenterContainer5/GoldText.text = ("X" + str(Player_Total_Golds))
	#$UpperPanel/CenterContainer/WavesCount.text = str(global_damage.return_wave()) + "/" + str(global_damage.get_total_waves())
func decreased_gold(value):
	Player_Total_Golds -= value
	update_player_gold()
	
func increased_gold(value):
	Player_Total_Golds += value
	update_player_gold()

func _hide_panel(value,skip=null):
	if value:
		if skip == null:
			print("JENO ")
			Pop_up_menu.visible = true
			get_tree().paused = true
		$UpperPanel.hide()
		$TowerLIst.hide()
		$Level.hide()
	else:
		if skip == null:
			print("CERBITO")
			Pop_up_menu.visible = false
			get_tree().paused = false
		$UpperPanel.show()
		$TowerLIst.show()
		$Level.show()
func _on_Menu_pressed():
	_hide_panel(true)
func _on_Pause_pressed():
	_hide_panel(false)
func _on_Cancel_pressed():
	pass

func _on_Tracking_pressed():
	pass

func switch_on(val):
	selecting = val
func _on_CheckButton_pressed():
	if not selecting:
		selecting = true
	else:
		selecting = false
	emit_signal("selecting",selecting)
	emit_signal("deselect",selecting)
	


func _on_button_down(tower):
	emit_signal("building_mode",tower)

func _on_menu_entered():
	emit_signal("on_menu",true)

func _on_menu_exited():
	emit_signal("on_menu",false)


func _on_button_up(tower):
	pass
func set_label():
	$TowerLIst/Tower1/Price.text = str(tower_price["t1"])
	$TowerLIst/Tower2/Price.text = str(tower_price["t2"])
	$TowerLIst/Tower3/Price.text = str(tower_price["t3"])
	$TowerLIst/Tower4/Price.text = str(tower_price["t4"])
	$TowerLIst/Tower5/Price.text = str(tower_price["t5"])
func disabled_tower():
	var Total_Golds = Player_Total_Golds
	if Total_Golds < tower_price["t1"]:
		$TowerLIst/Tower1.disabled = true
	else:
		$TowerLIst/Tower1.disabled=false
	if Total_Golds < tower_price["t2"]:
		$TowerLIst/Tower2.disabled = true
	else:
		$TowerLIst/Tower2.disabled = false
	if Total_Golds < tower_price["t3"]:
		$TowerLIst/Tower3.disabled=true
	else:
		$TowerLIst/Tower3.disabled =false
	if Total_Golds < tower_price["t4"]:
		$TowerLIst/Tower4.disabled=true
	else:
		$TowerLIst/Tower4.disabled=false
	if Total_Golds < tower_price["t5"]:
		$TowerLIst/Tower5.disabled=true
	else:
		$TowerLIst/Tower5.disabled=false


func _on_Save_button_down():
	get_parent().save()

