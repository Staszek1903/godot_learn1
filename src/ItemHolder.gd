extends Node2D

signal detached
signal attached

var is_active setget set_active, get_active
var is_locked setget set_locked, get_locked
export (String) var accepted_node_group setget set_node_group

func _ready():
	pass
	
func spawn(scene :PackedScene):
	if scene == null or is_holding() : return
	
	var item = scene.instance()
	var active = get_active()
	set_active(true)
	add_child(item)
	#item.self_attach($AttachPoint/AttachSensor)
	$AttachPointActive.attach(item)
	set_active(active)
	
func destroy_attached() -> void:
	var node = $AttachPointActive.attached_node
	$AttachPointActive._on_detached()
	node.queue_free()
	
func force_detach():
	$AttachPointActive._on_detached()
	
	
func _on_attached(node):
	print("ItemHolder::attached")
	emit_signal("attached", node)
	
func _on_detached(node):
	emit_signal("detached", node)
	print("ItemHolder::detached")
	
func is_holding() -> bool:
	#print("is_holding ", $AttachPointActive.attached_node)
	return ($AttachPointActive.attached_node != null)
	
func get_attached_node() -> Node2D:
	return $AttachPointActive.attached_node
	
func set_active(value:bool) -> void:
	$AttachPointActive.is_active = value
	
func get_active() -> bool:
	return $AttachPointActive.is_active 

func set_locked(value:bool) -> void:
	$AttachPointActive.is_locked = value
	
func get_locked() -> bool:
	return $AttachPointActive.is_locked 
	
func set_node_group(group:String)->void:
	$AttachPointActive.accepted_node_group = group
