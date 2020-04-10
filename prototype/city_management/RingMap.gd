class_name RingMap
extends Resource


signal city_changed
signal thing_added


var city_navigator: CityNavigator

var segments_dictionary: Dictionary = { }
var search_dictionary: Dictionary = { }
var things_dictionary: Dictionary = { }




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



func register_thing(type: int, ring_vector: RingVector, object):
	var dic: Dictionary = things_dictionary if type >= Constants.THINGS else segments_dictionary
	
	dic[type] = dic.get(type, { })
	dic[type][ring_vector.ring] = dic[type].get(ring_vector.ring, { })
	dic[type][ring_vector.ring][ring_vector.segment] = object
	
	if type >= Constants.THINGS:
		emit_signal("thing_added")
	else:
		emit_signal("city_changed")


func unregister_thing(type: int, ring_vector: RingVector, object, emit_signal: bool = true):
	var dic: Dictionary = things_dictionary if type >= Constants.THINGS else segments_dictionary
	var type_dic: Dictionary = dic.get(type, { })
	var ring_dic: Dictionary = { }
	
	if not type_dic.empty():
		ring_dic = type_dic.get(ring_vector.ring, { })
		
		if ring_dic and ring_dic.get(ring_vector.segment) == object:
			ring_dic.erase(ring_vector.segment)
	
	if ring_dic.empty():
		type_dic.erase(type)
	
	if type_dic.empty():
		dic.erase(type)
	
	if emit_signal:
		if type >= Constants.THINGS:
			emit_signal("thing_added")
		else:
			emit_signal("city_changed")


func update_thing(old_type: int, new_type: int, ring_vector: RingVector, object):
	unregister_thing(old_type, ring_vector, object, false)
	register_thing(new_type, ring_vector, object)



func get_object_at_position(ring_vector: RingVector, from: int = Constants.Objects.EVERYTHING):
	var search_through: Dictionary = { }
	
	if not from == CityLayout.EVERYTHING:
		search_through = segments_dictionary[from]
	else:
		search_through = search_dictionary
	
	return search_through.get(ring_vector.ring, { }).get(ring_vector.segment, null)


func get_thing_at_position(ring_vector: RingVector, type: int):
	var search_through: Dictionary = things_dictionary.get(type, { })
	
	return search_through.get(ring_vector.ring, { }).get(ring_vector.segment, null)
