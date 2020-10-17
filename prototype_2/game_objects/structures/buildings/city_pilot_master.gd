class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


export(Array, Constants.Resources) var _requests: Array = [ ]
export var _request_everything: bool = false


var requests: Array = [ ]


var _job_postings: Array = [ ]




# Called when the node enters the scene tree for the first time.
func _ready():
	requests = _requests.duplicate()
	
	if _request_everything:
		requests.clear()
		
		for value in Constants.Resources.values():
			requests.append(value)
	
	post_job(false, true)
	
#	for request in dic:
#		owner.add_to_group("%s%s" % [Constants.REQUEST, request])




func post_job(how_many_workers = 1, request_until_capacity: bool = false):
	_job_postings.append(_quarter_master.post_job(owner, self, how_many_workers, request_until_capacity))
