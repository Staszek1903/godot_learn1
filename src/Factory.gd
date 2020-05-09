extends Node2D

onready var label := $Screen
onready var timer := $Timer
onready var anims := $AnimationPlayer
onready var button := $GameButton
onready var door := $OutputDoor
onready var input := $InputDoor
onready var battery_socket := $BatterySocket

enum State {IDLE, PRODUCING, FULL}
var state: int = State.IDLE

export (int) var production_time := 1
export var spawn_scene: PackedScene

func _ready():
	$GameButton.state = true
	$OutputDoor/ItemHolder.is_active = false
	
# warning-ignore:unused_argument
func _process(delta):
	if timer.time_left != 0 : 
		label.text = String(timer.time_left).substr(0,3)
		
func _on_GameButton_state_change(button_state):
	if are_produce_requirements_met(button_state):
		 produce()
	else: button.state = true
		
func are_produce_requirements_met(button_state:bool) -> bool:
	return (self.state == State.IDLE and 
		not button_state and 
		battery_socket.is_holding() and
		input.is_holding())
	
func produce():
	battery_socket.is_locked = true
	
	button.is_active = false
	state = State.PRODUCING
	input.close()
	
	yield(input, "closed")
	$InputDoor/ItemHolder.destroy_attached()
	
	anims.play("open")
	yield(anims, "animation_finished")
	battery_socket.get_attached_node().power_load = 9.9
	timer.start(production_time)
	yield(timer, "timeout")
	battery_socket.get_attached_node().power_load = 0
	anims.play("close")
	yield(anims, "animation_finished")
	
	state = State.FULL
	door.dispense(spawn_scene)
	yield(door, "dispensed")
	state = State.IDLE
	input.open()
	$GameButton.is_active = true
	$GameButton.state = true
	
	battery_socket.is_locked = false
	
func _on_battery_runout():
	timer.stop()
	battery_socket.get_attached_node().power_load = 0.0
	battery_socket.force_detach()
	
	anims.play("close")
	yield(anims, "animation_finished")
	input.open()
	state = State.IDLE
	button.is_active = true
	button.state = true
	battery_socket.is_locked = false
	
func _on_BatterySocket_attached(batt):
	batt.connect("runout", self, "_on_battery_runout")

func _on_BatterySocket_detached(batt):
	batt.disconnect("runout", self, "_on_battery_runout")
