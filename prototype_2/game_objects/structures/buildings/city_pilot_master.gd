class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


export(PackedScene) var _available_job


var _job_posting: JobQueue.JobPosting = null
var _assigned_gatherers: Dictionary = { }


onready var _custodian: Custodian = $custodian




# Called when the node enters the scene tree for the first time.
func _ready():
	if needs_workers():
		_post_job()




func employ_worker(puppet_master: Node2D):
	var new_job: JobMachine = _available_job.instance()
	
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
	_assigned_gatherers[gathering_resource].append(puppet_master)
	assert(_assigned_gatherers[gathering_resource].size() <= how_many_of_item(gathering_resource))


func unassign_gatherer(puppet_master: Node2D, gathering_resource):
	_assigned_gatherers[gathering_resource].erase(puppet_master)


func can_be_gathered(gathering_resource) -> bool:
	var worker_array: Array = _assigned_gatherers.get(gathering_resource, [ ])
	
	return worker_array.size() < how_many_of_item(gathering_resource)



func _post_job():
	_job_posting = _quarter_master.post_job(self)

func _unpost_job():
	_quarter_master.unpost_job(_job_posting)
