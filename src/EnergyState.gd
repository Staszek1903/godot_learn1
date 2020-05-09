extends Node2D

onready var template :String = $Label.text
var energy:float = 123.321
var energy_delta:float = 0.0

var users = {}

func _ready():
	$Label.text = template % energy

func _process(delta):
	energy += energy_delta*delta
	if energy_delta != 0 : $Label.text = template % energy

func _on_energy_sub(node:Node, value:float):
	energy_delta += value
	if users.has(node):
		users[node] += value
	else:
		users[node] = value
		
func _on_energy_unsub(node:Node):
	energy_delta -= users[node]
	users.erase(node)
