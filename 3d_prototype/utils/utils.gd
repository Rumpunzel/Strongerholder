class_name Utils

static func find_node_of_type_in_children(parent_node: Node, node_type: Script, include_grandchildren := false, first_time_being_called := true) -> Node:
	var node: Node = null
	var children := parent_node.get_children()
	
	for child in children:
		if child is node_type:
			node = child
		elif include_grandchildren:
			node = find_node_of_type_in_children(child, node_type, include_grandchildren, false)
		
		if node:
			break
	
	if first_time_being_called and not node:
		printerr("Node in parent %s of type %s not found" % [ parent_node.name, node_type ])
		assert(false)
	
	return node
