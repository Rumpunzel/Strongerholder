class_name InputMaster, "res://class_icons/game_objects/game_actors/icon_input_master.svg"
extends Area2D


const PERSIST_AS_PROCEDURAL_OBJECT: bool = true

const PERSIST_PROPERTIES := [ "name", "_first_time" ]
const PERSIST_OBJ_PROPERTIES := [ "_inventories", "_reversed_inventories", "_main_inventory" ]


var _first_time: bool = true

var _inventories: Array = [ ]
var _reversed_inventories: Array = [ ]

var _main_inventory




func _ready() -> void:
	if _first_time:
		_first_time = false
		
		_initialise_inventories()
		
		_reversed_inventories = _inventories.duplicate()
		_reversed_inventories.invert()




func process_commands(state_machine: ObjectStateMachine, player_controlled: bool = false) -> void:
	var commands: Array = _get_input(player_controlled)
	
	for command in commands:
		command.execute(state_machine)



func pick_up_item(item: GameResource) -> bool:
	for inventory in _inventories:
		if in_range(item) and _item_belongs_in_inventory(inventory, item):
			inventory.pick_up_item(item)
			return true
	
	return false


func drop_item(item: GameResource, position_to_drop: Vector2 = global_position) -> void:
	for inventory in _reversed_inventories:
		if inventory.drop_item(item, position_to_drop):
			break

func drop_all_items(position_to_drop: Vector2 = global_position) -> void:
	for inventory in _reversed_inventories:
		inventory.drop_all_items(position_to_drop)

func recieve_transferred_item(item: GameResource) -> bool:
	for inventory in _inventories:
		if _item_belongs_in_inventory(inventory, item):
			inventory.transfer_item(item)
			return true
	
	return false


func initialise_starting_items(starting_items: Dictionary) -> void:
	for item in starting_items.keys():
		for _i in range(starting_items[item]):
			var new_item: GameResource = GameClasses.spawn_class_with_name(item)
			
			new_item.appear(false)
			_recieve_spawned_item(new_item)

func _recieve_spawned_item(item: GameResource) -> bool:
	for inventory in _inventories:
		if _item_belongs_in_inventory(inventory, item):
			inventory._add_item(item)
			return true
	
	return false


func _item_belongs_in_inventory(inventory: Inventory, item: GameResource) -> bool:
	return inventory == _main_inventory or (inventory is Refinery and (inventory as Refinery).input_resources[item.type] > 0) or (inventory is ToolBelt and item is Spyglass)


func has_item(resource_type: String) -> GameResource:
	for inventory in _reversed_inventories:
		var item: GameResource = inventory.has(resource_type)
		
		if item:
			return item
	
	return null


func get_inventory_contents(only_main_inventory: bool = false) -> Array:
	if only_main_inventory:
		return _main_inventory.get_contents()
	
	var contents: Array = [ ]
	
	for inventory in _reversed_inventories:
		contents += inventory.get_contents()
	
	return contents


func how_many_of_item(item_type: String) -> Array:
	var item_count: Array = [ ]
	
	for item in get_inventory_contents():
		if item.type == item_type:
			item_count.append(item)
	
	return item_count


# This currently takes either a GameResource or a GameClasses._GameClass so not static typing
func has_inventory_space_for(item) -> bool:
	if item.can_carry <= 0:
		return true
	
	return (_main_inventory.capacity_left() - 1.0 / float(item.can_carry)) >= 0.0


func in_range(object: PhysicsBody2D) -> bool:
	return get_overlapping_bodies().has(object)


func interact_with(structure: StaticBody2D) -> void:
	if in_range(structure):
		structure.operate()




func _get_input(_player_controlled: bool) -> Array:
	var commands: Array = [ ]
	
#	if Input.is_action_pressed("open_menu") -> void:
#		commands.append(MenuCommand.new())
	
#	if Input.is_action_pressed("interact") -> void:
#		commands.append(InteractCommand.new(hit_box.currently_highlighting))
#		#get_tree().set_input_as_handled()
	
	var movement_vector: Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands




func _initialise_inventories() -> void:
	_main_inventory = Inventory.new()
	_main_inventory.name = "Inventory"
	add_child(_main_inventory)
	_inventories.append(_main_inventory)





class Command:
	func execute(_state_machine: ObjectStateMachine) -> void:
		pass



class MoveCommand extends Command:
	var movement_vector: Vector2
	var sprinting: bool
	
	func _init(new_movement_vector: Vector2, new_sprinting: bool = false) -> void:
		movement_vector = new_movement_vector
		sprinting = new_sprinting
	
	func execute(state_machine: ObjectStateMachine) -> void:
		(state_machine as ActorStateMachine).move_to(movement_vector, sprinting)



class GiveCommand extends Command:
	var what_to_give: GameResource
	var whom_to_give_to: Node2D
	
	func _init(new_what_to_give: GameResource, new_whom_to_give_to: Node2D) -> void:
		what_to_give = new_what_to_give
		whom_to_give_to = new_whom_to_give_to
	
	func execute(state_machine: ObjectStateMachine) -> void:
		(state_machine as ActorStateMachine).give_item(what_to_give, whom_to_give_to)


class TakeCommand extends Command:
	var what_to_take: GameResource
	
	func _init(new_what_to_take: GameResource) -> void:
		what_to_take = new_what_to_take
	
	func execute(state_machine: ObjectStateMachine) -> void:
		if state_machine is ActorStateMachine:
			(state_machine as ActorStateMachine).take_item(what_to_take)
		elif state_machine is StructureStateMachine:
			(state_machine as StructureStateMachine).take_item(what_to_take)
		else:
			assert(false)


class RequestCommand extends Command:
	var request
	var whom_to_ask: Node2D
	
	func _init(new_request, new_whom_to_ask: Node2D) -> void:
		request = new_request
		whom_to_ask = new_whom_to_ask
	
	func execute(state_machine: ObjectStateMachine) -> void:
		(state_machine as ActorStateMachine).request_item(request, whom_to_ask)



class AttackCommand extends Command:
	var weapon: CraftTool
	
	func _init(new_weapon: CraftTool) -> void:
		weapon = new_weapon
	
	func execute(state_machine: ObjectStateMachine) -> void:
		(state_machine as ActorStateMachine).attack(weapon)


class InteractCommand extends Command:
	var structure: Node2D
	
	func _init(new_structure: Node2D) -> void:
		structure = new_structure
	
	func execute(state_machine: ObjectStateMachine) -> void:
		(state_machine as ActorStateMachine).operate(structure)



#class MenuCommand extends Command:
#	func execute(state_machine: ObjectStateMachine) -> void:
#		state_machine.open_menu(RadiantUI.new(["Stockpile", "Woodcutters Hut"], state_machine))
