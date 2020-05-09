extends "res://src/Attachable.gd"

onready var acid: Position2D = $AcidOrigin
export (float) var cappacity := 100.0
var power : float =  cappacity
var power_load : float = 0;

signal runout
signal full

func _ready():
	add_to_group("batteries")
	pass

func _process(delta):
	var acid_scale: float = power / cappacity
	acid.scale = Vector2(1, acid_scale)
	power -= power_load * delta
	if power < 0:
		power = 0;
		emit_signal("runout")
		
	if power >= cappacity:
		power = cappacity
		emit_signal("full")
		
	#if(power_load != 0): print(power)
