class_name Refinery, "res://class_icons/game_objects/structures/icon_refinery.svg"
extends Inventory


const PERSIST_PROPERTIES_2 := [ "production_steps", "steps_done" ]
const PERSIST_OBJ_PROPERTIES_2 := [ "input_resources", "output_resources" ]


signal resources_refined


var input_resources: Dictionary = { }
var output_resources: Dictionary = { }

var production_steps: int
var steps_done: int = 0


onready var _quarter_master = ServiceLocator.quarter_master




func pick_up_item(item: GameResource) -> void:
	item.unregister_resource()
	
	.pick_up_item(item)



func check_item_numbers() -> bool:
	if input_resources.empty():
		return false
	
	var content: Dictionary = { }
	
	for item in get_contents():
		content[item.type] = content.get(item.type, 0) + 1
	
	for item in input_resources.keys():
		if not content.get(item, 0) >= input_resources[item]:
			return false
	
	return true



func refine_prodcut() -> void:
	steps_done += 1
	
	if steps_done < production_steps:
		return
	
	steps_done = 0
	
	
	# TODO: optimise this; n^3 yuk
	for item in input_resources.keys():
		for _i in range(input_resources[item]):
			for resource in get_children():
				if resource.type == item:
					remove_child(resource)
					_quarter_master.unregister_resource(resource)
					resource.queue_free()
					break
	
	for item in output_resources.keys():
		for _i in range(output_resources[item]):
			var new_item: GameResource = GameClasses.spawn_class_with_name(item)
			
			new_item.appear(false)
			emit_signal("resources_refined", new_item)
