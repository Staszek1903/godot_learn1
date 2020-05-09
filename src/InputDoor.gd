extends Position2D

signal opened
signal closed
signal dispensed
signal attached
signal detached

onready var anim = $AnimationPlayer
onready var holder = $ItemHolder

export (String) var accepted_node_group = "" setget set_accepted_node_group

var opened : bool = false setget ,get_opened
func get_opened() -> bool:
	return opened

func _ready():
	holder.set_active(false)
	open()
	pass
	
func open() -> void:
	holder.set_active(true)
	anim.play("open")
	yield(anim, "animation_finished")
	opened = true;
	emit_signal("opened")
	
func close() -> void:
	opened = false;
	holder.set_active(false)
	anim.play("close")
	yield(anim, "animation_finished")
	emit_signal("closed")
	
func destroy_attached() -> void:
	$ItemHolder.destroy_attached()
	
func is_holding() -> bool :
	return holder.is_holding()
	
func set_accepted_node_group(group :String) -> void:
	$ItemHolder.accepted_node_group = group


func _on_ItemHolder_attached(node):
	print("InputDoor::artached: ", node)
	emit_signal("attached",node)

func _on_ItemHolder_detached(node):
	print("InputDoor::detached")
	emit_signal("detached")
