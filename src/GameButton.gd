extends Area2D

signal state_change(state)

onready var label:= $Label
onready var sprite:= $Sprite
onready var texture_on :Texture = load("res://png/Objects/Switch (1).png")
onready var texture_off :Texture = load("res://png/Objects/Switch (2).png")

var is_active :bool = true
var is_player_in_range :bool = false
var state :bool = false setget set_state, get_state

func _ready() -> void:
	sprite.texture = texture_off

func _input(event: InputEvent) -> void:
	if(event.is_action_pressed("interaction") and is_player_in_range and is_active):
		self.state = not state
		emit_signal("state_change",state)

# warning-ignore:unused_argument
func _on_GameButton_body_entered(body: Node) -> void:
	label.visible = true
	is_player_in_range = true

# warning-ignore:unused_argument
func _on_GameButton_body_exited(body: Node) -> void:
	label.visible = false
	is_player_in_range = false

func set_state(value:bool) -> void:
	state = value
	sprite.texture = texture_on if state else texture_off

func get_state() -> bool:
	return state
