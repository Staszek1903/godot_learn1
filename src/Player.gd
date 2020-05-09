extends Actor
class_name Player
# Declare 

onready var anim_sprt: AnimatedSprite = $AnimatedSprite

export (int,0,1000) var inertia = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	print("helooo buooois")

# warning-ignore:unused_argument
func _physics_process(delta: float) ->void:
	if(Input.is_action_pressed("move_left")): velocity.x = -speed.x
	elif(Input.is_action_pressed("move_right")): velocity.x = speed.x
	else: velocity.x = 0;
	velocity = move_and_slide(velocity, Vector2.UP, false,4,0.785398, false)
	#print(is_on_floor())
	
	if(Input.is_action_just_pressed("move_left") or 
	Input.is_action_just_pressed("move_right")): 
		anim_sprt.play("Run")
	if(Input.is_action_just_released("move_left") or 
	Input.is_action_just_released("move_right")):
		anim_sprt.play("Idle")
		
	if not is_on_floor(): anim_sprt.play("Jump")
	elif anim_sprt.animation == "Jump": anim_sprt.play("Idle")
		
	if(velocity.x < 0): anim_sprt.flip_h = true
	if(velocity.x > 0): anim_sprt.flip_h = false
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("bodies"):
			collision.collider.apply_central_impulse(-collision.normal * inertia)

func _input(event):
	#print("handled: ", event.as_text())
	if(event.is_action_pressed("jump")):
		if( is_on_floor() ):
			velocity.y = -speed.y;
		

func _on_EnemyDetect_area_entered(area: Area2D) -> void:
	velocity.y = -1000
	print("enemy detected ", area.get_name())


func _on_EnemyDetect_body_entered(body: Node) -> void:
	print("enemy body detected ", body.get_name())
	PlayerScore.deaths +=1
	queue_free()
	
