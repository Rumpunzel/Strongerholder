extends ActionLeaf

enum ActionType { GATHERS, DELIVERS }

export(ActionType) var _action_type
export var _all_items := true
export var _only_this_many := 1

func on_update(blackboard: CharacterBlackboard) -> int:
	var interaction_objects := [ _employer ] if _interaction_area.objects_in_interaction_range.has(_employer) else [ ]
	var amount := _how_many
	
	if _all:
		if _interaction_type == CharacterController.ItemInteraction.InteractionType.GIVE:
			amount = _inventory.count(_interaction_item)
		elif _interaction_type == CharacterController.ItemInteraction.InteractionType.TAKE:
			amount = _inventory.space_for(_interaction_item)
	
	_interaction_area.interact_with_specific_object(_employer, interaction_objects, _interaction_type, _interaction_item, amount, _all, false)

