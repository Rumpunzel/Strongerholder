class_name EmployerInteractionResource
extends StateActionResource

export(InteractionArea.InteractionType) var _interaction_type
export(Resource) var _override_interaction_item
export var _how_many := 1
export var _all := true

func _create_action() -> StateAction:
	return EmployerInteraction.new(_interaction_type, _override_interaction_item, _how_many, _all)


class EmployerInteraction extends StateAction:
	var _employer: Workstation
	var _inventory: CharacterInventory
	var _interaction_area: InteractionArea
	
	var _interaction_type: int
	var _interaction_item: ItemResource
	var _how_many: int
	var _all: bool
	
	
	func _init(interaction_type: int, interaction_item: ItemResource, how_many: int, all: bool) -> void:
		_interaction_type = interaction_type
		_interaction_item = interaction_item
		_how_many = how_many
		_all = all
	
	
	func awake(state_machine: Node) -> void:
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
		
		if not _interaction_item:
			match _interaction_type:
				InteractionArea.InteractionType.GIVE:
					# warning-ignore:unsafe_property_access
					_interaction_item = state_machine.current_job.gathers
				
				InteractionArea.InteractionType.TAKE:
					# warning-ignore:unsafe_property_access
					_interaction_item = state_machine.current_job.delivers
		
		_inventory = Utils.find_node_of_type_in_children(state_machine.owner, CharacterInventory)
		_interaction_area = Utils.find_node_of_type_in_children(state_machine.owner, InteractionArea)
	
	
	func on_update(_delta: float) -> void:
		var interaction_objects := [ _employer ] if _interaction_area.objects_in_interaction_range.has(_employer) else [ ]
		var amount := _how_many
		
		if _all and _interaction_type == InteractionArea.InteractionType.GIVE:
			amount = _inventory.count(_interaction_item)
		
		_interaction_area.interact_with_specific_object(_employer, interaction_objects, _interaction_type, _interaction_item, amount, _all, false)
