extends "res://src/Actor.gd"


func _ready() -> void:
	velocity.x = speed.x


# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if is_on_wall(): velocity.x *= -1;
	velocity.y = move_and_slide(velocity, Vector2.UP).y



func _on_StompDetect_body_entered(body: Node) -> void:	
	if(body.global_position.y < get_node("StompDetect").global_position.y): 
		get_node("CollisionShape2D").disabled = true;
		PlayerScore.score += 10
		queue_free()

