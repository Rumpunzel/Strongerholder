class_name Utils

static func find_node_of_type_in_children(parent_node: Node, node_type: Script, include_grandchildren := true) -> Node:
	var node: Node = null
	var children := parent_node.get_children()
	
	for child in children:
		if child is node_type:
			node = child
		else:
			node = find_node_of_type_in_children(child, node_type, include_grandchildren)
		
		if node:
			break
	
	return node
