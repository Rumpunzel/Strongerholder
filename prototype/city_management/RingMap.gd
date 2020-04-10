class_name RingMap
extends Resource


signal city_changed
signal resources_changed


var city_navigator: CityNavigator

var search_dictionary: Dictionary = { }

var structures: RingDictionary = RingDictionary.new()
var resources: RingDictionary = RingDictionary.new()
var requests: RingDictionary = RingDictionary.new()




func _init():
	city_navigator = CityNavigator.new(self)




func done_building():
	construct_search_dictionary()
	city_navigator.start_building()



func construct_search_dictionary():
	for type in structures.dictionary.values():
		for ring in type.keys():
			for block in type[ring].keys():
				search_dictionary[ring] = search_dictionary.get(ring, { })
				search_dictionary[ring][block] = type[ring][block]



func get_structures_at_position(ring_vector: RingVector, from: int = Constants.Objects.EVERYTHING) -> Array:
	var search_through: Dictionary = { }
	
	if not from == Constants.Objects.EVERYTHING:
		search_through = structures.dictionary[from]
	else:
		search_through = search_dictionary
	
	return search_through.get(ring_vector.ring, { }).get(ring_vector.segment, [ ])


func get_resources_at_position(ring_vector: RingVector, type: int) -> Array:
	var search_through: Dictionary = resources.dictionary.get(type, { })
	return search_through.get(ring_vector.ring, { }).get(ring_vector.segment, [ ])




func register_structure(type: int, ring_vector: RingVector, object):
	structures.register_in_dictionary(type, ring_vector, object)
	emit_signal("city_changed")


func unregister_structure(type: int, ring_vector: RingVector, object, emit_signal: bool = true):
	structures.unregister_in_dictionary(type, ring_vector, object)
	if emit_signal:
		emit_signal("city_changed")


func update_structure(old_type: int, new_type: int, ring_vector: RingVector, object):
	unregister_structure(new_type, ring_vector, object, false)
	register_structure(old_type, ring_vector, object)




func register_resource(type: int, ring_vector: RingVector, object):
	resources.register_in_dictionary(type, ring_vector, object)
	emit_signal("resources_changed")


func unregister_resource(type: int, ring_vector: RingVector, object, emit_signal: bool = true):
	resources.unregister_in_dictionary(type, ring_vector, object)
	if emit_signal:
		emit_signal("resources_changed")


func update_resource(old_type: int, new_type: int, ring_vector: RingVector, object):
	unregister_resource(old_type, ring_vector, object, false)
	register_resource(new_type, ring_vector, object)



func register_request(type: int, ring_vector: RingVector, object):
	requests.register_in_dictionary(type, ring_vector, object)


func unregister_request(type: int, ring_vector: RingVector, object):
	requests.unregister_in_dictionary(type, ring_vector, object)


func update_request(old_type: int, new_type: int, ring_vector: RingVector, object):
	unregister_resource(old_type, ring_vector, object)
	register_resource(new_type, ring_vector, object)
