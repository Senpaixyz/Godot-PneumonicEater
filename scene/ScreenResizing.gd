extends Node2D

var screen_size : Vector2 = Vector2()

func _ready():
	screen_size = OS.get_screen_size()
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D,SceneTree.STRETCH_ASPECT_EXPAND,Vector2(720,440),1)
	
func _process(_delta):
	if OS.get_screen_size() != screen_size:
		screen_size = OS.get_screen_size()
		OS.set_window_size(screen_size)
