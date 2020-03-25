extends GameObject
class_name BuildingFundament


const BUILDING_OFFSET:float = 2.0


export(SpatialMaterial) var highlight_material


onready var fundament = $building setget , get_fundament
onready var area = $building/area


var highlighted_by:GameActor = null



# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	
	area.connect("body_entered", self, "entered")
	area.connect("body_exited", self, "exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _unhandled_input(event):
	if highlighted:
		if event.is_action_pressed("interact"):
			print(name)
			get_tree().set_input_as_handled()



func entered(body):
	var object = body.get_parent()
	
	if object is Player:
		highlighted_by = object
		set_highlighted(true)

func exited(body):
	var object = body.get_parent()
	
	if object is Player:
		highlighted_by = null
		set_highlighted(false)



func calculate_distance_to_center() -> float:
	return fundament.global_transform.origin.distance_to(Vector3())


func handle_highlighted():
	fundament.get_node("block").material_override = highlight_material if highlighted else null



func set_world_position(new_position:Vector3):
	fundament.transform.origin = new_position + BUILDING_OFFSET * Vector3.FORWARD



func get_fundament():
	return fundament


func get_world_position():
	return fundament.global_transform.origin - BUILDING_OFFSET * Vector3.FORWARD
