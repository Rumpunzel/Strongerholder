class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


const PERSIST_PROPERTIES_2 := ["_available_job", "_storage", "_posted_job"]
const PERSIST_OBJ_PROPERTIES_4 := ["_city_structure", "_custodian", "_assigned_gatherers"]


const STORAGE = "STORAGE"


var _available_job
var _storage: bool

var _city_structure: CityStructure = null
var _custodian: Custodian = null

var _assigned_gatherers: Dictionary = { }

var _posted_job: bool = false




# Called when the node enters the scene tree for the first time.
func _ready():
	if not _city_structure:
		_city_structure = get_parent()
	
	if _storage:
		_city_structure.add_to_group(STORAGE)


func _process(_delta: float):
	if _posted_job:
		return
	
	if needs_workers():
		_post_job()
		
		_posted_job = true




func employ_worker(puppet_master: Node2D):
	var new_job = _available_job.new()
	new_job.name = "job"
	
	puppet_master.assign_job(new_job)
	
	if not needs_workers():
		_unpost_job()
	
	new_job._setup(self, puppet_master, _custodian.get_available_tool())
	
	yield(get_tree(), "idle_frame")
	
	new_job.activate(true)


func needs_workers() -> bool:
	return _custodian.still_has_tools()



func assign_gatherer(puppet_master: Node2D, gathering_resource):
	_assigned_gatherers[gathering_resource] = _assigned_gatherers.get(gathering_resource, [ ])
	
	if not _assigned_gatherers[gathering_resource].has(puppet_master):
		_assigned_gatherers[gathering_resource].append(puppet_master)
	assert(_assigned_gatherers[gathering_resource].size() <= how_many_of_item(gathering_resource))


func unassign_gatherer(puppet_master: Node2D, gathering_resource):
	_assigned_gatherers[gathering_resource].erase(puppet_master)


func can_be_gathered(gathering_resource) -> bool:
	var worker_array: Array = _assigned_gatherers.get(gathering_resource, [ ])
	
	return worker_array.size() < how_many_of_item(gathering_resource)



func can_be_operated() -> bool:
	for inventory in _inventories:
		if inventory is Refinery and inventory.check_item_numbers():
			return true
	
	return false


func refine_resource():
	for inventory in _inventories:
		if inventory is Refinery:
			inventory.refine_prodcut()



func _post_job():
	_quarter_master.post_job(self)

func _unpost_job():
	_quarter_master.unpost_job(self)


func _initialise_inventories():
	var new_refinery: Refinery = Refinery.new()
	new_refinery.name = "refinery"
	add_child(new_refinery)
	_inventories.append(new_refinery)
	
	_custodian = Custodian.new()
	_custodian.name = "custodian"
	add_child(_custodian)
	_inventories.append(_custodian)
	
	._initialise_inventories()


func _initialise_refineries(input_resources: Array, _output_resources: Array, _production_steps: int):
	for inventory in _inventories:
		if inventory is Refinery:
			inventory.input_resources = input_resources
			inventory._output_resources = _output_resources
			inventory._production_steps = _production_steps
