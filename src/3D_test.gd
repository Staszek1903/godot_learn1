extends Spatial


func _ready():
	pass
	
# warning-ignore:unused_argument
func _process(delta):
	$MeshInstance.rotate(Vector3.UP, 0.01)
