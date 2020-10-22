class_name WorkerQueue, "res://assets/icons/icon_worker_queue.svg"
extends Queue



func add_worker(puppet_master: Node2D):
	queue.append(puppet_master)
	
	#print("\nWORKER APPLICATIONS\n%s\n" % [queue])



func remove_worker(puppet_master: Node2D):
	queue.erase(puppet_master)





class WorkerProfile:
	var puppet_master: Node2D
	
	
	func _init(new_puppet_master: Node2D):
		puppet_master = new_puppet_master
	
	
	func _to_string() -> String:
		return "\nWorker: %s\n" % [puppet_master.owner.name]




class Errand:
	var craft_tool: Spyglass
	var use
	
	func _init(new_craft_tool: Spyglass, new_use):
		assert(new_craft_tool)
		craft_tool = new_craft_tool
		use = new_use
	
	func _to_string() -> String:
		return "%s: %s" % [craft_tool.name, use]
