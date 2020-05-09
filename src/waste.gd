extends Area2D

onready var anim := $AnimationPlayer

func _on_Waste_body_entered(body: Node) -> void:
	$CollisionShape2D.disabled = true
	anim.stop()
	anim.play("fade")

func catched() -> void:
	PlayerScore.score +=1
	queue_free()
