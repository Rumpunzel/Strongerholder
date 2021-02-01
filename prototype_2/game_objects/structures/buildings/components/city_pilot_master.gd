class_name CityPilotMaster, "res://class_icons/game_objects/structures/icon_city_pilot_master.svg"
extends PilotMaster


const PERSIST_PROPERTIES_2 := ["available_job", "storage_resources", "_posted_job"]
const PERSIST_OBJ_PROPERTIES_4 := ["_custodian", "_assigned_gatherers"]


var available_job
var storage_resources: Array = [ ]

var _custodian: Custodian = null
var _assigned_gatherers: Dictionary = { }
var _posted_job: bool = false




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for resource in storage_resources:
		_quarter_master.register_storage(game_object, resource)



func _process(_delta: float) -> void:
	if _posted_job:
		return
	
	if needs_workers():
		_post_job()
		
		_posted_job = true




func employ_worker(puppet_master: Node2D) -> void:
	var available_tool: Spyglass = _custodian.get_available_tool()
	
	if not available_tool:
		_unpost_job()
		return
	
	var new_job = available_job.new()
	new_job.name = "job"
	
	puppet_master.assign_job(new_job)
	
	if not needs_workers():
		_unpost_job()
	
	new_job._setup(self, game_object, puppet_master)
	
	yield(get_tree(), "idle_frame")
	
	new_job.dedicated_tool = available_tool
	new_job.activate(true, available_tool.type)


func needs_workers() -> bool:
	return _custodian.still_has_tools()



func assign_gatherer(puppet_master: Node2D, gathering_resource) -> void:
	_assigned_gatherers[gathering_resource] = _assigned_gatherers.get(gathering_resource, [ ])
	
	if not _assigned_gatherers[gathering_resource].has(puppet_master):
		_assigned_gatherers[gathering_resource].append(puppet_master)
	assert(_assigned_gatherers[gathering_resource].size() <= how_many_of_item(gathering_resource).size())


func unassign_gatherer(puppet_master: Node2D, gathering_resource) -> void:
	_assigned_gatherers[gathering_resource].erase(puppet_master)


func can_be_gathered(gathering_resource, puppet_master: Node2D, is_employee: bool) -> bool:
	if not (is_employee or storage_resources.has(gathering_resource)):
		return false
	
	var assigned_workers: Array = _assigned_gatherers.get(gathering_resource, [ ])
	
	if assigned_workers.has(puppet_master):
		return true
	
	var available_items: Array = how_many_of_item(gathering_resource)
	var effective_workers: int = 0 if available_items.empty() else assigned_workers.size() * available_items.front().how_many_can_be_carried
	
	return effective_workers < available_items.size()



func can_be_operated() -> bool:
	for inventory in _inventories:
		if inventory is Refinery and inventory.check_item_numbers():
			return true
	
	return false


func refine_resource() -> void:
	for inventory in _inventories:
		if inventory is Refinery:
			inventory.refine_prodcut()



func _post_job() -> void:
	_quarter_master.post_job(self)

func _unpost_job() -> void:
	_quarter_master.unpost_job(self)


func _initialise_inventories() -> void:
	var new_refinery: Refinery = Refinery.new()
	new_refinery.name = "refinery"
	add_child(new_refinery)
	_inventories.append(new_refinery)
	
	_custodian = Custodian.new()
	_custodian.name = "custodian"
	add_child(_custodian)
	_inventories.append(_custodian)
	
	._initialise_inventories()


func _initialise_refineries(input_resources: Array, output_resources: Array, production_steps: int) -> void:
	for inventory in _inventories:
		if inventory is Refinery:
			inventory.game_object = self
			inventory.input_resources = input_resources
			inventory.output_resources = output_resources
			inventory.production_steps = production_steps
