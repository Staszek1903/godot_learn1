extends Position2D

signal opened
signal closed
signal dispensed

onready var anim = $AnimationPlayer
onready var holder = $ItemHolder

func _ready():
	holder.set_active(false)
	pass
	
func open() -> void:
	anim.play("open")
	yield(anim, "animation_finished")
	emit_signal("opened")
	
func close() -> void:
	anim.play("close")
	yield(anim, "animation_finished")
	emit_signal("closed")
	
func dispense(scene: PackedScene) -> void:
	holder.spawn(scene)
	anim.play("open")
	yield(anim, "animation_finished")
	if holder.is_holding() : yield(holder, "detached")
	anim.play("close")
	yield(anim, "animation_finished")
	emit_signal("dispensed")
	
