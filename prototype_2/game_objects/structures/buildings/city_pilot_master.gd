class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


export(Array, Constants.Resources) var _requests: Array = [ ]
export var _request_everything: bool = false
export var _fill_until_capacity: bool = false

export var _has_worker_limit: bool = true
export var _workers_employed: int = 1


var requests: Array = [ ]


var _job_postings: Array = [ ]




# Called when the node enters the scene tree for the first time.
func _ready():
	requests = _requests.duplicate()
	
	if _request_everything:
		requests.clear()
		
		for value in Constants.Resources.values():
			requests.append(value)
	
	# warning-ignore-all:incompatible_ternary
	_post_job(_workers_employed if _has_worker_limit else false, _fill_until_capacity)




func requests_fulfilled() -> bool:
	if _fill_until_capacity:
		# TODO: put in capacity calculation in here
		return false
	
	var requests_check: Array = requests.duplicate()
	var inventory_contents: Array = _inventory.get_contents()
	
	for item in inventory_contents:
		requests_check.erase(item.type)
		
		if requests_check.empty():
			return true
	
	return false



func _post_job(how_many_workers = 1, request_until_capacity: bool = false):
	_job_postings.append(_quarter_master.post_job(owner, self, how_many_workers, request_until_capacity))
