extends Position2D

var is_active := true #when not active imposible to attach item
var is_locked := false # when locked imposible to detach item
var attached_node : Node2D

signal attached
signal detached

export var accepted_node_group = ""

func _ready():
	pass # Replace with function body.

func _on_AttachSensor_area_entered(area):
	var attach_point = area.get_parent()
	var node :Node2D = attach_point.get_parent()
	
	print("AttachPoint::attach_group:" + accepted_node_group)
	if not accepted_node_group == "" and not node.is_in_group(accepted_node_group):
		return 
		
	if attached_node == null and is_active and area.get_name() == "AttachSensorPasive" :
		attached_node = node
		print("AttachPoint::AreaEnteredAndAccepted")
		call_deferred("attach", node)

# warning-ignore:unused_argument
func _on_AttachSensorActive_area_exited(area):
	print("AttachPoint::AreaExited")

func _on_detached():
	if is_locked : return
	var root := get_tree().get_root()
	
	attached_node.disconnect("detached", self, "_on_detached")
	
	remove_child(attached_node)
	root.add_child(attached_node)
	attached_node.is_attached = false
	attached_node.set_mode_rigid()
	attached_node.set_position(get_global_position() -
		attached_node.get_attach_offset())
	attached_node.set_rotation( get_global_rotation() + PI)
	
	var impulse := Vector2.UP
#	var trans := Transform2D(attached_node.get_global_rotation(),
#		Vector2.ZERO)
#	impulse = trans.basis_xform_inv(impulse)
#	print(impulse)
	
	attached_node.call_deferred("apply_impulse",
		Vector2.ZERO,
		impulse*1000)
	
	emit_signal("detached", attached_node)
	attached_node = null
	
	

func attach(node:Node2D)->void:
	node.let_go()	
	var attach_offset = node.get_attach_offset()
	node.set_position(attach_offset)
	node.set_rotation(PI)
	
	node.get_parent().remove_child(node)
	add_child(node)
			
# warning-ignore:return_value_discarded
	node.connect("detached", self, "_on_detached")
	
	node.set_mode_static()
	node.is_attached = true
	attached_node = node
	
	emit_signal("attached", node)



