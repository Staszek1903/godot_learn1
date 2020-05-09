extends Node2D

onready var label := $Screen
onready var timer := $Timer
onready var anims := $AnimationPlayer
onready var button := $GameButton
onready var door := $OutputDoor
onready var battery_socket := $BatterySocket

export var spawn_scene: PackedScene

enum State {IDLE, PRODUCING, FULL}
var state: int = State.IDLE

export (int) var production_time := 1

func _ready():
	button.state = true
	
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
		battery_socket.is_holding())
	
func produce():
	battery_socket.is_locked = true

	button.is_active = false
	state = State.PRODUCING
	
	anims.play("open")
	yield(anims, "animation_finished")
	
	battery_socket.get_attached_node().power_load = 10.001
	timer.start(production_time)
	yield(timer, "timeout")
	if battery_socket.is_holding() : 
		battery_socket.get_attached_node().power_load = 0.0
	
	
	anims.play("close")
	yield(anims, "animation_finished")
	
	state = State.FULL
	door.dispense(spawn_scene)
	yield(door, "dispensed")
	
	state = State.IDLE
	button.is_active = true
	button.state = true
	
	battery_socket.is_locked = false
	
func _on_battery_runout():
	print("BATTERY RUNOUT")
	battery_socket.get_attached_node().power_load = 0.0
	battery_socket.is_locked = false
	battery_socket.force_detach()
	
	if timer.time_left < 0.1 : return
	timer.stop()
	anims.play("close")
	yield(anims, "animation_finished")
	state = State.IDLE
	button.is_active = true
	button.state = true




func _on_BatterySocket_attached(batt):
	batt.connect("runout", self, "_on_battery_runout")


func _on_BatterySocket_detached(batt):
	batt.disconnect("runout", self, "_on_battery_runout")
