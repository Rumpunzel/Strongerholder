class_name ResourceStateMachine, "res://assets/icons/icon_resource_state_machine.svg"
extends ObjectStateMachine


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := ["name", "history"]
const PERSIST_OBJ_PROPERTIES := ["current_state", "hit_points_max", "indestructible", "hit_points"]



func drop_item(objects_layer: YSort, position_to_drop: Vector2):
	current_state.drop_item(objects_layer, position_to_drop)


func pick_up_item(new_invetory: Inventory):
	current_state.pick_up_item(new_invetory)
