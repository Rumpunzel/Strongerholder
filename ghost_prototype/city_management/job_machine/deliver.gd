class_name JobStateDeliver, "res://class_icons/states/icon_state_deliver.svg"
extends JobStateMoveTo


const PERSIST_OBJ_PROPERTIES := [ "_delivery_target" ]


var _delivery_target: CityStructure = null




func _ready() -> void:
	name = DELIVER




func check_for_exit_conditions(employee: PuppetMaster, _employer: CityStructure, _dedicated_tool: Spyglass) -> void:
	if employee.get_inventory_contents(true).empty():
		exit(IDLE)




func enter(parameters: Array = [ ]) -> void:
	if not parameters.empty():
		assert(parameters.size() == 1 and parameters[0])
		
		_delivery_target = parameters[0]
	
	.enter([_delivery_target.global_position])


func exit(next_state: String, parameters: Array = [ ]) -> void:
	_delivery_target = null
	
	.exit(next_state, parameters)




func next_command(employee: PuppetMaster, _dedicated_tool: Spyglass) -> InputMaster.Command:
	var job_items: Array = employee.get_inventory_contents(true)
	
	if not job_items.empty():
		var item: GameResource = job_items.front()
		
		item.unassign_worker(employee)
		
		return InputMaster.GiveCommand.new(item, _delivery_target)
	
	return InputMaster.Command.new()


func current_target() -> GameObject:
	return _delivery_target
