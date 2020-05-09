tool
extends Area2D

onready var anim_player = $AnimationPlayer
onready var door_open : Sprite = $DoorOpen

var is_door_open : bool = false

export (PackedScene) var next_scene

var opened:bool = false;

func _ready() -> void:
	var tree = get_tree()
	print("node_count: ",tree.get_node_count())

func _get_configuration_warning() -> String:
	return "Drzwi do nikąd :(" if not next_scene else ""

func _on_Portal_body_entered(body: Node) -> void:
	if is_door_open: anim_player.play("fade_out")
	
func transmision() -> void:
	if next_scene:
		get_tree().change_scene_to(next_scene)
	anim_player.play("fade_in")
	
func _on_button_signal(state: bool) -> void:
	door_open.visible = state
	is_door_open = state
