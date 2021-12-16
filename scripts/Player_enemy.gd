extends Node

var Play = preload("res://scripts/Player.gd")
var obstacle = preload("res://scripts/CircleRotation.gd")
var Player = Play.new()
var Number = obstacle.new()
func get_connection():
	print("HELLO")

func get_number():
	pass
