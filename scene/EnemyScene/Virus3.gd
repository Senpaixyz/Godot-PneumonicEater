extends "res://scripts/WhiteBloodCells.gd"

var ATTACK_PER_SECONDS = -2
export(int) var DAMAGE = 75 # TEMPORARY
export(float) var ATTACK_GAP = 0.49
var Tag = "Virus3"
var Health = 0
func _ready():
	$AttackInterval.wait_time = ATTACK_GAP


func _on_AttackInterval_timeout():
	ATTACK_PER_SECONDS += 1
	$Attack/CollisionShape2D.scale.x = ATTACK_PER_SECONDS
	$Attack/CollisionShape2D.scale.y = ATTACK_PER_SECONDS
	if ATTACK_PER_SECONDS >= 2:
		ATTACK_PER_SECONDS = -2
