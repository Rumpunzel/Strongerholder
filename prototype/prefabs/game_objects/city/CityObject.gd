class_name CityObject
extends GameObject


const BUILD_INTO_FUNCTION = "build_into"

const object_scenes: Dictionary = {
	Constants.Objects.TREE: preload("res://prefabs/game_objects/city/things/tree.tscn"),
	Constants.Objects.BASE: preload("res://prefabs/game_objects/city/buildings/base.tscn"),
	Constants.Objects.FOUNDATION: preload("res://prefabs/game_objects/city/buildings/foundation.tscn"),
	Constants.Objects.BRIDGE: preload("res://prefabs/game_objects/city/buildings/bridge.tscn"),
	Constants.Objects.STOCKPILE: preload("res://prefabs/game_objects/city/buildings/stockpile.tscn"),
	Constants.Objects.WOODCUTTERS_HUT: preload("res://prefabs/game_objects/city/buildings/woodcutters_hut.tscn"),
}

const highlight_material: Material = preload("res://assets/materials/highlightShader.material")


var object:CityStructure = null setget , get_object

var object_width: int = 1
var is_building: bool = true




func _init(new_type: int, new_ring_vector: RingVector, new_ring_map: RingMap, building: bool = true, new_width: int = 1, new_inventory = null).(new_ring_map):
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


func interact(sender: GameObject) -> bool:
	return object and .interact(sender)


func build_into(new_type):
	if new_type is String:
		new_type = new_type.replace(" ", "_").to_upper()
		new_type = Constants.Objects.values()[Constants.Objects.keys().find(new_type)]
	
	set_type(new_type)
	
	ring_map.update_segment(type, new_type, ring_vector, self)


func die(sender: GameObject):
	if sender is GameActor and sender.get_object_of_interest() == self:
		sender.set_object_of_interest(null)
	
	sender.give(inventory, self)
	
	if object:
		object.queue_free()
		object = null
		
		ring_map.unregister_thing(type, ring_vector, self)
		
		.die(sender)



func set_type(new_type: int):
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
	
	name = "[%s:(%s, %s)]" % [Constants.enum_name(Constants.Objects, type), ring_vector.ring, ring_vector.segment]


func set_ring_vector(new_vector: RingVector):
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
			var new_vector: RingVector = RingVector.new(0, 0)
			new_vector.set_equal_to(ring_vector)
			new_vector.segment += int(ceil(i / 2.0) * (1 if i % 2 == 0 else -1))
			
			new_active = new_active and ring_map.get_things_at_position(new_vector, Constants.Objects.TREE).empty()
		
		set_active(new_active)
	
	return active
