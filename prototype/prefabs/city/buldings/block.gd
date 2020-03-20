tool
extends GameObject
class_name BuildingFundament


onready var fundament = $building setget , get_fundament
onready var area = $building/area



# Called when the node enters the scene tree for the first time.
func _ready():
	area.connect("body_entered", self, "entered")
	area.connect("body_exited", self, "exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func entered(_body):
	pass

func exited(_body):
	pass



func calculate_distance_to_center() -> float:
	return fundament.global_transform.origin.distance_to(Vector3())


func handle_highlighted():
	fundament.rotation.z = (PI / 2.0) if highlighted else 0.0



func set_world_position(new_position:Vector3):
	fundament.transform.origin = new_position


func get_fundament():
	return fundament

func get_ring_radius() -> float:
	return .get_ring_radius() + Hill.BUILDING_OFFSET

func get_world_position():
	return fundament.global_transform.origin
