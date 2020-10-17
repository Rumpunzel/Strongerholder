class_name WorkerQueue, "res://assets/icons/icon_worker_queue.svg"
extends Node


var _queue: Array = [ ]




func add_worker(game_actor: PuppetMaster, invetory: Inventory, tool_belt: ToolBelt):
	var new_profile: WorkerProfile = WorkerProfile.new(game_actor, invetory, tool_belt)
	
	_queue.append(new_profile)
	_queue.sort_custom(WorkerProfile, "sort_ascending")
	
	print(_queue)


func requeue(worker_profile: WorkerProfile):
	_queue.append(worker_profile)



func pop_front() -> Object:
	return _queue.pop_front()


func empty() -> bool:
	return _queue.empty()





class WorkerProfile:
	
	var game_actor: PuppetMaster
	
	var inventory: Inventory
	var tool_belt: ToolBelt
	
	
	
	func _init(new_game_actor: PuppetMaster, new_inventory: Inventory, new_tool_belt: ToolBelt):
		game_actor = new_game_actor
		
		inventory = new_inventory
		tool_belt = new_tool_belt
	
	
	
	func can_do_job_now(potential_jobs: Array) -> GameResource:
		var items: Array = _get_inventory_contents()
		
		for item in items:
			if potential_jobs.has(item.type):
				return item
		
		return null
	
	
	func can_do_job_eventually(potential_jobs: Array) -> Errand:
		var craft_tools: Array = tool_belt.get_valid_targets()
		
		for craft_tool in craft_tools:
			for use in craft_tool.used_for:
				if potential_jobs.has(use):
					return Errand.new(craft_tool, use)
		
		return null
	
	
	
	func get_flexibility() -> int:
		return _get_inventory_contents().size() + _get_tool_uses().size()
	
	static func sort_ascending(a: WorkerProfile, b: WorkerProfile) -> bool:
		return a.get_flexibility() < b.get_flexibility()
	
	
	
	func _get_inventory_contents() -> Array:
		return inventory.get_content()
	
	func _get_tool_uses() -> Array:
		return tool_belt.get_valid_targets()




class Errand:
	
	var craft_tool: CraftTool
	var use
	
	
	func _init(new_craft_tool: CraftTool, new_use):
		craft_tool = new_craft_tool
		use = new_use
