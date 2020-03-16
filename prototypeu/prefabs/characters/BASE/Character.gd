extends Spatial
class_name Character

const RING_RADIUS = "ring_radius"
const RING_POSITION = "ring_position"

export var walkspeed:float = 50

export var ring_radius:float = 5
export var ring_position:float = 0

var up_down_modifier:float = 0.2

signal moved


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move(delta)


func move(delta):
	get_radius_change(delta)
	
	get_position_change(delta)
	
	rotation.y = ring_position
	
	emit_signal("moved", { RING_RADIUS: ring_radius, RING_POSITION: ring_position })
	

func get_radius_change(_delta:float):
	assert(false)

func get_position_change(_delta:float):
	assert(false)
