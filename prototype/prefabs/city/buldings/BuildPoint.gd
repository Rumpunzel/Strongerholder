extends GameObject
class_name BuildPoint

func is_class(type): return type == "BuildPoint" or .is_class(type)
func get_class(): return "BuildPoint"


const buildings:Dictionary = { RingMap.BASE: preload("res://prefabs/city/buldings/base.tscn"), RingMap.FOUNDATIONS: preload("res://prefabs/city/buldings/Foundation/Foundation.tscn"), RingMap.BRIDGES: preload("res://prefabs/city/buldings/bridge/bridge.tscn") }

const highlight_material:Material = preload("res://prefabs/city/buldings/debug_materials/highlight_material.tres")


var building_type:String setget set_building_type, get_building_type
var building:Foundation = null setget set_building, get_building



func _init(new_building_type:String, new_ring_vector:RingVector):
	set_building_type(new_building_type)
	set_ring_vector(new_ring_vector)


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	set_building(buildings[building_type].instance())
	set_world_position(Vector3(0, RingMap.get_height_minimum(ring_vector.ring), ring_vector.radius))
	
	RingMap.register_segment(building_type, ring_vector, self)



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


func build_into(new_building:Foundation, new_type:String):
	set_building(new_building)
	
	RingMap.update_segment(building_type, new_type, ring_vector, self)
	
	building_type = new_type




func set_building_type(new_type:String):
	building_type = new_type


func set_building(new_building:Foundation):
	if building:
		remove_child(building)
		building.queue_free()
		building = null
	
	building = new_building
	building.ring_vector = ring_vector
	add_child(building)


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
