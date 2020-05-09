extends Node

signal score_updated
signal player_died

var score:=0 setget set_score
var deaths:=0 setget die

func _ready() -> void:
	pass
	
func set_score(value: int)->void:
	score= value
	emit_signal("score_updated")
	
func die(value: int)->void:
	deaths = value
	emit_signal("player_died")
