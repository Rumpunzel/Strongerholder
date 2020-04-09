class_name ActorBehavior
extends Resource


const INVENTORY_EMPTY = "inventory_empty"
const RAW_MATERIAL = "raw_material"
const PROCESSED_MATERIAL = "processed_material"


const ACTOR_PRIORITIES = {
	Constants.Objects.PLAYER: { },
	Constants.Objects.WOODSMAN: {
		INVENTORY_EMPTY: Constants.Objects.TREE,
		RAW_MATERIAL: Constants.Objects.STOCKPILE,
	},
}


var priorities: Dictionary = { }




func _init(new_actor: int):
	set_priorities(new_actor)




func next_priority(inventory: Array):
	var status: String
	
	if inventory.empty():
		status = INVENTORY_EMPTY
	else:
		status = RAW_MATERIAL
	
	return priorities.get(status, Constants.Objects.NOTHING)


func set_priorities(new_actor: int):
	priorities = ACTOR_PRIORITIES[new_actor]
