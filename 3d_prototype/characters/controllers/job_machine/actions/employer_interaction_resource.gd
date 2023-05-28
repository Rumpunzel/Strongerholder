class_name EmployerInteractionResource
extends StateActionResource

export(Resource) var _override_interaction_item
export var _how_many := 1
export var _all := true

func _create_action() -> StateAction:
	return EmployerInteraction.new(_override_interaction_item, _how_many, _all)


class EmployerInteraction extends StateAction:
	var _employer: Workstation
	var _inventory: Inventory
	var _character_controller: CharacterController
	
	var _interaction_item: ItemResource
	var _how_many: int
	var _all: bool
	
	
	func _init(interaction_item: ItemResource, how_many: int, all: bool) -> void:
		_interaction_item = interaction_item
		_how_many = how_many
		_all = all
	
	
	func awake(state_machine: Node) -> void:
		# warning-ignore:unsafe_property_access
		_employer = state_machine.current_job.employer
		
#		if not _interaction_item:
#			match _interaction_type:
#				CharacterController.InteractionType.GIVE:
#					# warning-ignore:unsafe_property_access
#					_interaction_item = state_machine.current_job.gathers
#
#				CharacterController.InteractionType.TAKE:
#					# warning-ignore:unsafe_property_access
#					_interaction_item = state_machine.current_job.delivers
		
		_inventory = Utils.find_node_of_type_in_children(state_machine.owner, Inventory)
		_character_controller = Utils.find_node_of_type_in_children(state_machine.owner, CharacterController)
	
	
	func on_update(_delta: float) -> void:
		var interaction_objects := [ _employer ] if _character_controller.interaction_area.objects_in_area.has(_employer) else [ ]
		var amount := _how_many
		
#		if _all:
#			if _interaction_type == CharacterController.InteractionType.GIVE:
#				amount = _inventory.count(_interaction_item)
#			elif _interaction_type == CharacterController.InteractionType.TAKE:
#				amount = _inventory.space_for(_interaction_item)
		
#		_character_controller.interact_with_specific_object(_employer, interaction_objects, _interaction_type, _interaction_item, amount, _all, false)
