class_name RingDictionary
extends Resource


var dictionary: Dictionary = { } setget , get_dictionary



func register_in_dictionary(type: int, ring_vector: RingVector, object):
	dictionary[type] = dictionary.get(type, { })
	
	dictionary[type][ring_vector.ring] = dictionary[type].get(ring_vector.ring, { })
	
	dictionary[type][ring_vector.ring][ring_vector.segment] = dictionary[type][ring_vector.ring].get(ring_vector.segment, [ ])
	
	dictionary[type][ring_vector.ring][ring_vector.segment].append(object)


func unregister_in_dictionary(type: int, ring_vector: RingVector, object):
	var type_dic: Dictionary = dictionary.get(type, { })
	var ring_dic: Dictionary = { }
	var segment_array: Array = [ ]
	
	if not type_dic.empty():
		ring_dic = type_dic.get(ring_vector.ring, { })
		
		if not ring_dic.empty():
			segment_array = ring_dic.get(ring_vector.segment, [ ])
			
			if segment_array.has(object):
				segment_array.erase(object)
	
	
	if segment_array.empty():
		ring_dic.erase(segment_array)
	
	if ring_dic.empty():
		type_dic.erase(type)
	
	if type_dic.empty():
		dictionary.erase(type)


func update_in_dictionary(old_type: int, new_type: int, ring_vector: RingVector, object):
	unregister_in_dictionary(old_type, ring_vector, object)
	register_in_dictionary(new_type, ring_vector, object)



func get_dictionary() -> Dictionary:
	return dictionary
