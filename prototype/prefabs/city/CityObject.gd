extends GameObject
class_name CityObject

func is_class(class_type): return class_type == "CityPoint" or .is_class(class_type)
func get_class(): return "CityPoint"


const BUILD_INTO_FUNCTION = "build_into"

const object_scenes:Dictionary = {
	CityLayout.OBJECTS.TREE: preload("res://prefabs/city/things/tree.tscn"),
	CityLayout.OBJECTS.BASE: preload("res://prefabs/city/buildings/base.tscn"),
	CityLayout.OBJECTS.FOUNDATION: preload("res://prefabs/city/buildings/foundation.tscn"),
	CityLayout.OBJECTS.BRIDGE: preload("res://prefabs/city/buildings/bridge.tscn"),
	CityLayout.OBJECTS.STOCKPILE: preload("res://prefabs/city/buildings/stockpile.tscn"),
}

const highlight_material:Material = preload("res://assets/materials/highlightShader.material")


var object:CityStructure = null setget , get_object

var object_width:int = 1
var is_building:bool = true




func _init(new_type:int, new_ring_vector:RingVector, new_ring_map:RingMap, building:bool = true, new_width:int = 1, new_inventory = null).(new_ring_map):
	set_type(new_type)
	set_ring_vector(new_ring_vector)
	
	is_building = building
	object_width = new_width
	
	inventory.append(new_inventory)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_object()
	
	if is_building:
		ring_map.register_segment(type, ring_vector, self)
	else:
		ring_map.register_thing(type, ring_vector, self)
	
	yield(get_tree(), "idle_frame")
	
	ring_map.connect("thing_added", self, "get_active")




func handle_highlighted():
	if object:
		object.handle_highlighted(highlight_material if highlighted else null)


func interact(sender:GameObject) -> bool:
	if object:
		return object.interact(sender) and .interact(sender)
	
	return false and .interact(sender)


func build_into(new_type:int):
	set_type(new_type)
	
	ring_map.update_segment(type, new_type, ring_vector, self)


func die(sender:GameObject):
	if sender is GameActor and sender.object_of_interest == self:
		sender.set_object_of_interest(null)
	
	sender.give(inventory, self)
	
	if object:
		object.queue_free()
		object = null
		
		ring_map.unregister_thing(type, ring_vector, self)
		
		.die(sender)



func set_type(new_type:int):
	.set_type(new_type)
	
	if object:
		set_object()


func set_object():
	if object:
		remove_child(object)
		object.queue_free()
		object = null
	
	object = object_scenes[type].instance()
	
	object.transform.origin = Vector3(0, CityLayout.get_height_minimum(ring_vector.ring), ring_vector.radius)
	
	add_child(object)
	
	name = "[%s:(%s, %s)]" % [CityLayout.enum_name(CityLayout.OBJECTS, type), ring_vector.ring, ring_vector.segment]


func set_ring_vector(new_vector:RingVector):
	.set_ring_vector(new_vector)
	rotation.y = ring_vector.rotation
	
	if object:
		object.ring_vector = new_vector



func get_object() -> CityStructure:
	return object

func get_active() -> bool:
	if is_building:
		var new_active = true
		
		for i in range(object_width):
			var new_vector:RingVector = RingVector.new(0, 0)
			new_vector.set_equal_to(ring_vector)
			new_vector.segment += int(ceil(i / 2.0) * (1 if i % 2 == 0 else -1))
			
			new_active = new_active and ring_map.get_things_at_position(new_vector, CityLayout.OBJECTS.TREE).empty()
		
		set_active(new_active)
	
	return active
