extends GameObject
class_name BuildingFundament

func is_class(type): return type == "BuildingFundament" or .is_class(type)
func get_class(): return "BuildingFundament"


const BUILDING_OFFSET:float = 2.0


export(SpatialMaterial) var highlight_material


onready var fundament = $building setget , get_fundament
onready var area = $building/area



# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree(), "idle_frame")
	
	area.connect("body_entered", self, "entered")
	area.connect("body_exited", self, "exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func entered(body):
	var object = body.get_parent()
	
	if object is GameActor:
		object.focus_target = self
		
		if object is Player:
			set_highlighted(true)

func exited(body):
	var object = body.get_parent()
	
	if object is GameActor:
		if object.focus_target == self:
			object.focus_target = null
		
		if object is Player:
			set_highlighted(false)



func calculate_distance_to_center() -> float:
	return fundament.global_transform.origin.distance_to(Vector3())


func handle_highlighted():
	fundament.get_node("block").material_override = highlight_material if highlighted else null


func interact(sender:GameObject, action:String):
	print("%s %s with %s." % [sender.name, "interacted" if action == "" else action, name])



func set_world_position(new_position:Vector3):
	fundament.transform.origin = new_position + BUILDING_OFFSET * Vector3.FORWARD



func get_fundament():
	return fundament


func get_world_position():
	return fundament.global_transform.origin - BUILDING_OFFSET * Vector3.FORWARD
