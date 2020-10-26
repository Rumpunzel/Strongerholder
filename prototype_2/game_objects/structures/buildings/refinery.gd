class_name Refinery, "res://assets/icons/structures/icon_refinery.svg"
extends Inventory


const PERSIST_PROPERTIES_2 := ["_production_steps", "_steps_done"]
const PERSIST_OBJ_PROPERTIES := ["input_resources", "_output_resources"]


const _RESOURCE_SCENES = {
	Constants.Resources.WOOD: "res://game_objects/resources/wood.tscn",
	Constants.Resources.WOOD_PLANKS: "res://game_objects/resources/wood_planks.tscn",
	Constants.Resources.STONE: null,
	Constants.Resources.SPYGLASS: null,
	Constants.Resources.AXE: "res://game_objects/resources/tools/axe.tscn",
}


export(Array, Constants.Resources) var input_resources


export(Array, Constants.Resources) var _output_resources

export var _production_steps: int = 2


var _steps_done: int = 0




func pick_up_item(item: Node2D):
	item.unregister_resource()
	
	.pick_up_item(item)



func check_item_numbers() -> bool:
	var content: Dictionary = { }
	
	for item in get_contents():
		content[item.type] = content.get(item.type, 0) + 1
	
	for item in input_resources:
		if not content.get(item, 0) >= input_resources.count(item):
			return false
	
	return true



func refine_prodcut():
	_steps_done += 1
	
	if _steps_done < _production_steps:
		return
	
	_steps_done = 0
	
	
	for item in input_resources:
		for resource in get_children():
			if resource.type == item:
				remove_child(resource)
				get_parent()._quarter_master.unregister_resource(resource)
				resource.queue_free()
				break
	
	for item in _output_resources:
		var new_item: GameResource = load(_RESOURCE_SCENES[item]).instance()
		
		add_child(new_item)
		owner._state_machine.give_item(new_item, owner)
