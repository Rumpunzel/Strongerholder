tool
extends Resource
class_name RingMap


onready var city_navigator:CityNavigator


var segments_dictionary:Dictionary = { }
var search_dictionary:Dictionary = { }
var things_dictionary:Dictionary = { }


signal city_changed
signal thing_added



func _init():
	city_navigator = CityNavigator.new(self)




func done_building():
	construct_search_dictionary()
	city_navigator.start_building()



func construct_search_dictionary():
	for type in segments_dictionary.values():
		for ring in type.keys():
			for block in type[ring].keys():
				search_dictionary[ring] = search_dictionary.get(ring, { })
				search_dictionary[ring][block] = type[ring][block]



func register_segment(type:String, ring_vector:RingVector, object):
	segments_dictionary[type] = segments_dictionary.get(type, { })
	segments_dictionary[type][ring_vector.ring] = segments_dictionary[type].get(ring_vector.ring, { })
	segments_dictionary[type][ring_vector.ring][ring_vector.segment] = object
	
	emit_signal("city_changed")


func update_segment(old_type:String, new_type:String, ring_vector:RingVector, object):
	segments_dictionary[old_type] = segments_dictionary.get(old_type, { })
	segments_dictionary[old_type][ring_vector.ring] = segments_dictionary[old_type].get(ring_vector.ring, { })
	segments_dictionary[old_type][ring_vector.ring].erase(ring_vector.segment)
	
	register_segment(new_type, ring_vector, object)
	done_building()



func register_thing(type:String, ring_vector:RingVector, object):
	things_dictionary[type] = things_dictionary.get(type, { })
	things_dictionary[type][ring_vector.ring] = things_dictionary[type].get(ring_vector.ring, { })
	things_dictionary[type][ring_vector.ring][ring_vector.segment] = things_dictionary[type][ring_vector.ring].get(ring_vector.segment, [ ])
	things_dictionary[type][ring_vector.ring][ring_vector.segment].append(object)
	
	emit_signal("thing_added")


func unregister_thing(type:String, ring_vector:RingVector):
	things_dictionary[type] = things_dictionary.get(type, { })
	things_dictionary[type][ring_vector.ring] = things_dictionary[type].get(ring_vector.ring, { })
	things_dictionary[type][ring_vector.ring][ring_vector.segment] = things_dictionary[type][ring_vector.ring].get(ring_vector.segment, [ ])
	things_dictionary[type][ring_vector.ring].erase(ring_vector.segment)
	
	emit_signal("thing_added")


func update_thing(old_type:String, new_type:String, ring_vector:RingVector, object):
	unregister_thing(old_type, ring_vector)
	register_thing(new_type, ring_vector, object)



func get_object_at_position(ring_vector:RingVector, from:String = CityLayout.EVERYTHING):
	var search_through:Dictionary = { }
	
	if not from == CityLayout.EVERYTHING:
		search_through = segments_dictionary[from]
	else:
		search_through = search_dictionary
	
	return search_through.get(ring_vector.ring, { }).get(ring_vector.segment, null)
