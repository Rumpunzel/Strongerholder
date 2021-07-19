class_name ItemInteractionResource
extends StateActionResource

export(Resource) var item_to_gather

func _create_action() -> StateAction:
	return ItemInteraction.new(item_to_gather)


class ItemInteraction extends StateAction:
	var _interaction_area: InteractionArea
	var _item_resource: ItemResource
	
	
	func _init(item: ItemResource) -> void:
		_item_resource = item
	
	
	func awake(state_machine) -> void:
		var character: Character = state_machine.owner
		_interaction_area = character.get_interaction_area()
	
	
	func on_update(_delta: float) -> void:
		_interaction_area.interact_with_nearest(_item_resource)
