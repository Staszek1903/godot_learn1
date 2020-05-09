extends Node2D

onready var hand = $hand

export (float, 0.0, 1.5) var dead_angle = 0.1
const max_angle = 0.8

signal idle
signal moved

func _ready():
	pass

var prev_angle = 0.0
func _process(delta):
	var angle = hand.get_rotation()
	if abs(prev_angle) < dead_angle and abs(angle) > dead_angle: 
		emit_signal("moved", sign(angle))
	if abs(prev_angle) > dead_angle and abs(angle) < dead_angle:
		emit_signal("idle")
	prev_angle = angle
	
func get_angle() -> float:
	var angle = hand.get_rotation()
	return sign(angle) * ((abs(angle)-dead_angle)/(max_angle-dead_angle))
