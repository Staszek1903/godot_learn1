tool
extends Node2D

export (String, FILE, "*.tscn") var scene:= ""
onready var templ: PackedScene = load(scene)

func _ready() -> void:
	pass
	
func spawn()->void:
	var instance := templ.instance()
	add_child(instance)
	#instance.set_position()
	return

func _on_button_signal(state: bool):
	spawn()

func _get_configuration_warning() -> String:
		return "Brak resourca do spawnowania" if scene == "" else ""
