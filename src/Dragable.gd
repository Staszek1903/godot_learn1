extends RigidBody2D

export var drag_force := 1

var is_dragged: bool = false
var drag_offset: Vector2 = Vector2.ZERO

export (float,0,1) var drag_friction :float = 0.1

signal picked
signal released

func _ready() -> void:
	set_pickable(true)
	pass
	
# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	if Input.is_action_just_released("lmb"): let_go()
	if is_dragged:
		drag()
		apply_impulse(Vector2.ZERO, calculate_friction_impulse())
	
func calculate_friction_impulse() -> Vector2:
	var vel = get_linear_velocity()
	return (-vel * drag_friction)

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_action_pressed("lmb")): 
		pick()
		emit_signal("picked")
		
func _draw():
	if is_dragged: draw_force()
		
func pick():
	modulate.a = 0.5
	var mouse_pos := get_global_mouse_position()
	var pos := get_global_position()
	drag_offset = get_transform().basis_xform_inv(mouse_pos - pos)
	is_dragged = true
	
func let_go():
	is_dragged = false
	modulate.a = 1.0
	update()
	emit_signal("released")

func drag():
	var mouse_pos := get_global_mouse_position()
	var pos := get_global_position() + drag_offset
	var force_n := mouse_pos - pos
	var force_l := force_n.length()
	force_n = force_n.normalized()
	var force := force_n * force_l * drag_force 
	apply_impulse(get_transform().basis_xform(drag_offset),force)
	update()
	
func draw_force():
	var mouse_pos := get_global_mouse_position() #global stpace	
	var pos := get_global_position() # global space
	var t = get_transform()
	var local_mouse_pos :Vector2 = t.basis_xform_inv(mouse_pos - pos) # mouse pos in sprite space
	draw_line( drag_offset, local_mouse_pos, Color(255,255,255), 5)

	#draw_line(mouse_pos, pos, Color(100,100,200), 5)
