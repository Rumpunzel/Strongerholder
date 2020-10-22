class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


export(Array, Constants.Resources) var _requests: Array = [ ]


var requests: Array = [ ]


var _job_postings: Array = [ ]


onready var _custodian: Custodian = $custodian




# Called when the node enters the scene tree for the first time.
func _ready():
	requests = _requests.duplicate()
	
	_post_job()




func requests_fulfilled() -> bool:
	var requests_check: Array = requests.duplicate()
	var inventory_contents: Array = get_inventory_contents()
	
	for item in inventory_contents:
		requests_check.erase(item.type)
		
		if requests_check.empty():
			return true
	
	return false



func _post_job():
	_job_postings.append(_quarter_master.post_job(owner, self))
