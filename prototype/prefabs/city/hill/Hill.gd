tool
extends Spatial
class_name Hill


const BUILDING_OFFSET:float = 2.0
const BUILDING_SLOPE:float = 2.0

const NUMBER_OF_RINGS:int = 10



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



static func get_ring_height(ring_number:int) -> float:
	return -sqrt(ring_number * 40.0)
