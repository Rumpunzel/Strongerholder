class_name CityObject
extends RingObject


const BUILD_INTO_FUNCTION = "build_into"

const HIGHLIGHT_MATERIAL: Material = preload("res://assets/materials/highlightShader.material")

const BUILDING_REQUESTS = {
	Constants.Objects.STOCKPILE: [ Constants.Objects.WOOD, Constants.Objects.WOOD_PLANKS, ],
	Constants.Objects.WOODCUTTERS_HUT: [ Constants.Objects.WOOD ],
}


var object_scenes: Dictionary = {
	Constants.Objects.TREE: load("res://game_objects/city/things/tree.tscn"),
	Constants.Objects.BASE: load("res://game_objects/city/buildings/base.tscn"),
	Constants.Objects.FOUNDATION: load("res://game_objects/city/buildings/CityStructure.tscn"),
	Constants.Objects.BRIDGE: load("res://game_objects/city/buildings/bridge.tscn"),
	Constants.Objects.STOCKPILE: load("res://game_objects/city/buildings/stockpile.tscn"),
	Constants.Objects.WOODCUTTERS_HUT: load("res://game_objects/city/buildings/woodcutters_hut.tscn"),
}




func _init(new_type: int, new_ring_vector: RingVector, new_ring_map: RingMap, new_inventory = [ ]).(new_ring_map):
	set_type(new_type)
	set_ring_vector(new_ring_vector)
	
	connect("received_item", self, "register_item")
	connect("sent_item", self, "unregister_item")
	
	receive_items(new_inventory, null)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_object(object_scenes[type].instance())
	
	ring_map.register_structure(type, ring_vector, self)
	
	yield(get_tree(), "idle_frame")
	
	ring_map.connect("city_changed", self, "is_active")




func handle_highlighted():
	if object:
		object.handle_highlighted(HIGHLIGHT_MATERIAL if highlighted else null)


func interact(sender: RingObject) -> bool:
	return object and .interact(sender)


func register_item(new_item):
	ring_map.register_resource(new_item, ring_vector, self)


func unregister_item(new_item):
	ring_map.unregister_resource(new_item, ring_vector, self)



func build_into(new_type):
	if new_type is String:
		new_type = new_type.replace(" ", "_").to_upper()
		new_type = Constants.Objects.values()[Constants.Objects.keys().find(new_type)]
	
	set_type(new_type)
	
	for request in BUILDING_REQUESTS.get(new_type, [ ]):
		ring_map.register_resource(request + Constants.REQUEST, ring_vector, self)
	
	ring_map.update_structure(type, new_type, ring_vector, self)


func die(sender: RingObject):
	if sender:
		sender.receive_items(inventory, self)
	
	if object:
		object.queue_free()
		object = null
		
		ring_map.unregister_structure(type, ring_vector, self)
		
		.die(sender)




func set_ring_vector(new_vector: RingVector):
	.set_ring_vector(new_vector)
	rotation.y = ring_vector.rotation
	
	if object:
		object.ring_vector = new_vector


func set_type(new_type: int):
	.set_type(new_type)
	
	if object:
		set_object(object_scenes[type].instance())



func is_active() -> bool:
	if object:
		if Constants.object_type(type) == Constants.BUILDINGS:
			var new_active = true
			
			for i in range(object.object_width):
				var new_vector: RingVector = RingVector.new(0, 0)
				new_vector.set_equal_to(ring_vector)
				new_vector.segment += int(ceil(i / 2.0) * (1 if i % 2 == 0 else -1))
				
				new_active = new_active and ring_map.get_structures_at_position(new_vector, Constants.Objects.TREE).empty()
			
			set_active(new_active)
		
		return active and alive
	else:
		return false
