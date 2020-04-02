tool
extends GameObject
class_name BuildPoint

func is_class(class_type): return class_type == "BuildPoint" or .is_class(class_type)
func get_class(): return "BuildPoint"


const buildings:Dictionary = { CityLayout.BASE: preload("res://prefabs/city/buldings/base.tscn"), CityLayout.FOUNDATION: preload("res://prefabs/city/buldings/Foundation/Foundation.tscn"), CityLayout.BRIDGE: preload("res://prefabs/city/buldings/bridge/bridge.tscn"), CityLayout.STOCKPILE: preload("res://prefabs/city/buldings/stockpile/stockpile.tscn") }

const highlight_material:Material = preload("res://assets/materials/highlightShader.material")


var type:String setget set_type, get_type
var building:Foundation = null setget , get_building

var gui



func _init(new_type:String, new_ring_vector:RingVector, new_ring_map:RingMap, new_gui).(new_ring_map):
	set_type(new_type)
	set_ring_vector(new_ring_vector)
	gui = new_gui


# Called when the node enters the scene tree for the first time.
func _ready():
	set_building()
	
	ring_map.register_segment(type, ring_vector, self)



func entered(body):
	if ring_map.get_things_at_position(ring_vector, CityLayout.TREE).empty():
		var object = body.get_parent()
		
		if object is GameActor:
			object.add_focus_target(self)
			
			if object is Player:
				object.object_of_interest = self
				set_highlighted(true)


func exited(body):
	var object = body.get_parent()
	
	if object is GameActor:
		object.erase_focus_target(self)
		
		if object is Player:
			if object.object_of_interest == self:
				object.object_of_interest = null
			
			set_highlighted(false)
			
			gui.hide(self)



func handle_highlighted():
	if building:
		building.handle_highlighted(highlight_material if highlighted else null)


func interact(sender:GameObject) -> bool:
	if building:
		return building.interact(sender) and .interact(sender)
	
	return false and .interact(sender)


func build_into(new_type:String):
	set_type(new_type)
	
	ring_map.update_segment(type, new_type, ring_vector, self)




func set_type(new_type:String):
	type = new_type
	
	if building:
		set_building()


func set_building():
	if building:
		remove_child(building)
		building.queue_free()
		building = null
	
	building = buildings[type].instance()
	building.ring_vector = ring_vector
	building.gui = gui
	
	set_world_position(Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius))
	
	add_child(building)
	
	name = "[%s:(%s, %s)]" % [type, ring_vector.ring, ring_vector.segment]


func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.y = ring_vector.rotation
	
	if building:
		building.ring_vector = new_vector


func set_world_position(new_position:Vector3):
	if building:
		building.transform.origin = new_position
	else:
		.set_world_position(new_position)



func get_type() -> String:
	return type


func get_building() -> Foundation:
	return building


func get_world_position() -> Vector3:
	if building:
		return building.global_transform.origin
	else:
		return .get_world_position()
