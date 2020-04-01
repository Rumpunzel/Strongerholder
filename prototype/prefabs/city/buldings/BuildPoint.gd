tool
extends GameObject
class_name BuildPoint

func is_class(type): return type == "BuildPoint" or .is_class(type)
func get_class(): return "BuildPoint"


const buildings:Dictionary = { CityLayout.BASE: preload("res://prefabs/city/buldings/base.tscn"), CityLayout.FOUNDATION: preload("res://prefabs/city/buldings/Foundation/Foundation.tscn"), CityLayout.BRIDGE: preload("res://prefabs/city/buldings/bridge/bridge.tscn"), CityLayout.STOCKPILE: preload("res://prefabs/city/buldings/stockpile/stockpile.tscn") }

const highlight_material:Material = preload("res://assets/materials/highlightShader.material")


var building_type:String setget set_building_type, get_building_type
var building:Foundation = null setget , get_building

var gui



func _init(new_building_type:String, new_ring_vector:RingVector, new_ring_map:RingMap, new_gui).(new_ring_map):
	set_building_type(new_building_type)
	set_ring_vector(new_ring_vector)
	gui = new_gui


# Called when the node enters the scene tree for the first time.
func _ready():
	set_building()
	
	ring_map.register_segment(building_type, ring_vector, self)



func entered(body):
	var object = body.get_parent()
	
	if object is GameActor and not object.focus_targets.has(self):
		object.focus_targets.append(self)
		
		if object is Player:
			object.object_of_interest = self
			set_highlighted(true)

func exited(body):
	var object = body.get_parent()
	
	if object is GameActor:
		if object.focus_targets.has(self):
			object.focus_targets.erase(self)
		
		if object is Player:
			if object.object_of_interest == self:
				object.object_of_interest = null
			
			set_highlighted(false)
			
			gui.hide(self)



func handle_highlighted():
	if building:
		building.handle_highlighted(highlight_material if highlighted else null)


func interact(action:String, sender:GameObject) -> bool:
	print("%s %s with %s." % [sender.name, "interacted" if action == "" else action, name])
	
	if building:
		return building.interact(action, sender)
	
	return false


func build_into(new_type:String):
	set_building_type(new_type)
	
	ring_map.update_segment(building_type, new_type, ring_vector, self)




func set_building_type(new_type:String):
	building_type = new_type
	
	if building:
		set_building()


func set_building():
	if building:
		remove_child(building)
		building.queue_free()
		building = null
	
	building = buildings[building_type].instance()
	building.ring_vector = ring_vector
	building.gui = gui
	
	set_world_position(Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius))
	
	add_child(building)
	
	name = "[%s][%s, %s]" % [building_type, ring_vector.ring, ring_vector.segment]


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



func get_building_type() -> String:
	return building_type


func get_building() -> Foundation:
	return building


func get_world_position() -> Vector3:
	if building:
		return building.global_transform.origin
	else:
		return .get_world_position()
