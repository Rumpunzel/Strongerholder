class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


export(PackedScene) var _available_job


var _job_posting: JobQueue.JobPosting = null


onready var _custodian: Custodian = $custodian




# Called when the node enters the scene tree for the first time.
func _ready():
	_post_job()




func employ_worker(puppet_master: Node2D):
	var new_job: JobMachine = _available_job.instance()
	
	puppet_master.assign_job(new_job)
	
	new_job._setup(self, puppet_master, _custodian.get_available_tool())
	
	if not _custodian.still_has_tools():
		_unpost_job()



func _post_job():
	_job_posting = _quarter_master.post_job(self, _custodian.get_contents().size())

func _unpost_job():
	_quarter_master.unpost_job(_job_posting)
