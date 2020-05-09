extends KinematicBody2D
class_name Actor


# Declare
export var speed = Vector2(300,1000)

onready var gravity:float = ProjectSettings.get_setting("physics/2d/default_gravity")
var velocity:= Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta;
	return
