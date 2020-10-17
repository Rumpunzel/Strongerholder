class_name CityPilotMaster, "res://assets/icons/structures/icon_city_pilot_master.svg"
extends PilotMaster


export(Array, Constants.Resources) var requests: Array = [ ]
export var request_everything: bool = false


onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




# Called when the node enters the scene tree for the first time.
func _ready():
	var dic: Array = [ ]
	
	dic = requests.duplicate()
	
	if request_everything:
		dic.clear()
		
		for value in Constants.Resources.keys():
			dic.append(value)
	
	_quarter_master.post_job(self, dic, false, true)
	
#	for request in dic:
#		owner.add_to_group("%s%s" % [Constants.REQUEST, request])
