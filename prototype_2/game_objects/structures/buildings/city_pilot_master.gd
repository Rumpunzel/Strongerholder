class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


export(PackedScene) var _available_job


var requests: Array = [ ]


var _job_postings: Array = [ ]


onready var _custodian: Custodian = $custodian




# Called when the node enters the scene tree for the first time.
func _ready():
	_post_job()




func employ_worker(puppet_master: Node2D):
	var new_job: JobMachine = _available_job.instance()
	
	puppet_master.assign_job(new_job)
	
	new_job._setup(self, puppet_master, _custodian.get_available_tool())


func requests_fulfilled() -> bool:
	var requests_check: Array = requests.duplicate()
	var inventory_contents: Array = get_inventory_contents()
	
	for item in inventory_contents:
		requests_check.erase(item.type)
		
		if requests_check.empty():
			return true
	
	return false



func _post_job():
	_job_postings.append(_quarter_master.post_job(self, _custodian.get_contents().size()))
