tool
extends "res://src/Dragable.gd"

signal detached

var is_attached:bool = false

func _ready():
	pass
	
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	._on_input_event(viewport,event,shape_idx)
	if(event.is_action_pressed("lmb") and is_attached): 
		emit_signal("detached")
	
func set_mode_rigid(): mode = MODE_RIGID
func set_mode_static(): mode = MODE_STATIC

	
func get_attach_offset() -> Vector2:
	return $AttachPointPasive.get_position()

func _get_configuration_warning() -> String:
	return "Attachable element needs AttachPointPassive subnode to function" if ($AttachPointPasive == null) else ""

