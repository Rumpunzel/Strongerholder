tool
extends GameObject
class_name BuildingFundament

func is_class(type): return type == "BuildingFundament" or .is_class(type)
func get_class(): return "BuildingFundament"


const BUILDING_OFFSET:float = 2.0


export(SpatialMaterial) var highlight_material


var building:Building = null setget set_building, get_building
var area:Area = null setget set_area, get_area



# Called when the node enters the scene tree for the first time.
func _ready():
	pass


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
			
			GUI.hide(self)



func handle_highlighted():
	if building:
		building.handle_highlighted(highlight_material if highlighted else null)


func interact(sender:GameObject, action:String):
	print("%s %s with %s." % [sender.name, "interacted" if action == "" else action, name])
	
	if building:
		building.interact(sender, action)
		
		print("Which is a %s." % [building.name])


func build_into(new_building:Building):
	set_building(new_building)




func set_building(new_building:Building):
	var world_pos = (building.transform.origin - BUILDING_OFFSET * Vector3.FORWARD) if building else Vector3()
	
	if building:
		remove_child(building)
		building.queue_free()
		building = null
	
	building = new_building
	add_child(new_building)
	set_world_position(world_pos)
	building.ring_vector = ring_vector
	
	set_area(building.area)


func set_area(new_area:Area):
	area = new_area
	
	area.connect("body_entered", self, "entered")
	area.connect("body_exited", self, "exited")


func set_ring_vector(new_vector:Vector2):
	.set_ring_vector(new_vector)
	
	if building:
		building.ring_vector = new_vector


func set_world_position(new_position:Vector3):
	if building:
		building.transform.origin = new_position + BUILDING_OFFSET * Vector3.FORWARD
	else:
		.set_world_position(new_position)



func get_building() -> Building:
	return building


func get_area() -> Area:
	return area


func get_world_position() -> Vector3:
	if building:
		return building.global_transform.origin - BUILDING_OFFSET * Vector3.FORWARD
	else:
		return .get_world_position()
