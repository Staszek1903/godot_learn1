extends Node2D

onready var fuel_ind =  $FuelInd
onready var temp_ind =  $TempInd
onready var pow_ind =  $OutInd

onready var socked = $BatterySocket
onready var lever = $Lever
onready var button = $GameButton
onready var input = $InputDoor
onready var rods = $ControlRods
onready var rods_init_pos = rods.get_position();

const rods_max_pos = 150.0
const fuel_use_const = 1

const temperature_prod_const = 10
const temperature_defuse_const = 0.1
const min_temp_to_power = 50
const temp_prod_const = 0.02
const power_defuse_const = 0.1

var fuel :float =0.0
var rods_fraction =0.0
var temperature:float =0.0
var power:float =0.0

var rods_moving: bool = false

func _ready():
	pass
	
func _process(delta):
	update_rods(delta)
	update_state(delta)
	update_screens()
	
func update_rods(delta):
	if rods_moving and fuel > 0:
		rods_fraction += lever.get_angle() * delta;
		rods_fraction = 0 if rods_fraction < 0 else 1 if rods_fraction > 1 else rods_fraction
		
	if fuel <= 0 and rods_fraction > -0.1 :
		rods_fraction -= delta
		if(!input.opened) : input.open();
		
	if fuel >0 and rods_fraction < 0.0 :
		rods_fraction += delta
		
	rods.set_position(Vector2(rods_init_pos.x, rods_init_pos.y - (rods_max_pos * rods_fraction)))

func update_state(delta):
	var reactivity = rods_fraction if rods_fraction >0 else 0.0
	fuel -= reactivity * fuel_use_const * delta
	temperature += reactivity * temperature_prod_const * delta
	temperature -= temperature_defuse_const * temperature * delta
	temperature = temperature if temperature>0 else 0.0
	
	power += max((temperature - min_temp_to_power) * temp_prod_const * delta, 0)
	power -= power_defuse_const * power * delta
	power = power if power > 0 else 0
	
	if socked.is_holding():
		socked.get_attached_node().power_load = -power
	
	
	#print(fuel," ",temperature," ", power)
	
	
func update_screens():
	fuel_ind.text = String(fuel).substr(0,3)
	temp_ind.text = String(temperature).substr(0,3)
	pow_ind.text = String(power).substr(0,3)

func _on_GameButton_state_change(state):
	if(input.is_holding()):
		input.close()
		yield(input, "closed")
		input.destroy_attached()
		fuel += 100;
		update_screens()
	else : button.state = false

func _on_InputDoor_attached(node):
	button.state = true

func _on_InputDoor_detached(node):
	button.state = false

func _on_Lever_idle():
	rods_moving = false

func _on_Lever_moved(side):
	rods_moving = true

func _on_BatterySocket_attached(batt):
	batt.connect("full", self, "_on_batt_full")
	batt.connect("runout", self, "_on_batt_runout")
	print("batt connected")

func _on_BatterySocket_detached(batt):
	batt.disconnect("full", self, "_on_batt_full")
	batt.disconnect("runout", self, "_on_batt_runout")
	print("batt disconnected")
	
func _on_batt_full():
	socked.get_attached_node().power_load = 0;
	socked.force_detach()

func _on_batt_runout():
	socked.get_attached_node().power_load = 0;
	socked.force_detach()
