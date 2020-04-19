extends Node


signal city_changed
signal resources_changed


var search_dictionary: Dictionary = { }

var structures: RingDictionary = RingDictionary.new()
var resources: RingDictionary = RingDictionary.new()


onready var city_navigator: CityNavigator = CityNavigator.new(self)




func done_building():
	construct_search_dictionary()
	city_navigator.start_building()



func construct_search_dictionary():
	for type in structures.dictionary.values():
		for ring in type.keys():
			for block in type[ring].keys():
				search_dictionary[ring] = search_dictionary.get(ring, { })
				search_dictionary[ring][block] = type[ring][block]



func get_structures_at_position(ring_vector: RingVector, from: int = Constants.EVERYTHING) -> Array:
	var search_through: Dictionary = { }
	
	if not from == Constants.EVERYTHING:
		search_through = structures.dictionary[from]
	else:
		search_through = search_dictionary
	
	return search_through.get(ring_vector.ring, { }).get(ring_vector.segment, [ ])


func get_resources_at_position(ring_vector: RingVector, type: int) -> Array:
	var search_through: Dictionary = resources.dictionary.get(type, { })
	return search_through.get(ring_vector.ring, { }).get(ring_vector.segment, [ ])




func register_structure(type: int, object):
	structures.register_in_dictionary(type, object.ring_vector, object)
	emit_signal("city_changed")


func unregister_structure(type: int, object, emit_signal: bool = true):
	structures.unregister_in_dictionary(type, object.ring_vector, object)
	if emit_signal:
		emit_signal("city_changed")


func update_structure(old_resource: int, new_resource: int, object):
	unregister_structure(new_resource, object, false)
	register_structure(old_resource, object)




func register_resource(resource: String, object):
	resources.register_in_dictionary(resource, object.ring_vector, object)
	emit_signal("resources_changed")


func unregister_resource(resource: String, object, emit_signal: bool = true):
	resources.unregister_in_dictionary(resource, object.ring_vector, object)
	if emit_signal:
		emit_signal("resources_changed")


func update_resource(old_resource: String, new_resource: String, object):
	unregister_resource(old_resource, object, false)
	register_resource(new_resource, object)
