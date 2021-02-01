class_name Refinery, "res://class_icons/structures/icon_refinery.svg"
extends Inventory


const PERSIST_PROPERTIES_2 := ["production_steps", "steps_done"]
const PERSIST_OBJ_PROPERTIES_2 := ["game_object", "input_resources", "output_resources"]


const RESOURCE_SCENES = {
	Constants.Resources.LUMBER: "res://game_objects/resources/lumber.tscn",
	Constants.Resources.WOOD_PLANKS: "res://game_objects/resources/wood_plank.tscn",
	Constants.Resources.STONE: null,
	Constants.Resources.SPYGLASS: null,
	Constants.Resources.AXE: "res://game_objects/resources/tools/axe.tscn",
}


var game_object: Node2D = null

var input_resources: Array = [ ]
var output_resources: Array = [ ]

var production_steps: int
var steps_done: int = 0


onready var _quarter_master: QuarterMaster = ServiceLocator.quarter_master




func pick_up_item(item: Node2D) -> void:
	item.unregister_resource()
	
	.pick_up_item(item)



func check_item_numbers() -> bool:
	if input_resources.empty():
		return false
	
	var content: Dictionary = { }
	
	for item in get_contents():
		content[item.type] = content.get(item.type, 0) + 1
	
	for item in input_resources:
		if not content.get(item, 0) >= input_resources.count(item):
			return false
	
	return true



func refine_prodcut() -> void:
	steps_done += 1
	
	if steps_done < production_steps:
		return
	
	steps_done = 0
	
	
	for item in input_resources:
		for resource in get_children():
			if resource.type == item:
				remove_child(resource)
				_quarter_master.unregister_resource(resource)
				resource.queue_free()
				break
	
	for item in output_resources:
		var new_item: Node2D = load(RESOURCE_SCENES[item]).instance()
		
		add_child(new_item)
		new_item.appear(false)
		game_object.transfer_item(new_item)
