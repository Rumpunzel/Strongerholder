class_name InputMaster, "res://assets/icons/game_actors/icon_input_master.svg"
extends Area2D


var _inventories: Array = [ ]
var _reversed_inventories: Array = [ ]


onready var _main_inventory: Inventory = $inventory




func _ready():
	for child in get_children():
		if child is Inventory:
			_inventories.append(child)
	
	_reversed_inventories = _inventories.duplicate()
	_reversed_inventories.invert()




func process_commands(state_machine: ObjectStateMachine):
	#object_of_interest, null, global_position, _current_path
	var commands: Array = _get_input()
	
	for command in commands:
		command.execute(state_machine)



func pick_up_item(item: GameResource) -> bool:
	for inventory in _inventories:
		if _in_range(item) and (inventory == _main_inventory or (inventory is Refinery and inventory.input_resources.has(item.type)) or (inventory is ToolBelt and item is Spyglass)):
			inventory.pick_up_item(item)
			return true
	
	return false


func drop_item(item: GameResource, position_to_drop: Vector2 = global_position):
	for inventory in _reversed_inventories:
		if inventory.drop_item(item, position_to_drop):
			break

func drop_all_items(position_to_drop: Vector2 = global_position):
	for inventory in _reversed_inventories:
		inventory.drop_all_items(position_to_drop)


func has_item(resource_type) -> GameResource:
	for inventory in _reversed_inventories:
		var item: GameResource = inventory.has(resource_type)
		
		if item:
			return item
	
	return null


func get_inventory_contents() -> Array:
	var contents: Array = [ ]
	
	for inventory in _reversed_inventories:
		contents += inventory.get_contents()
	
	return contents


func how_many_of_item(item_type) -> int:
	var item_count: int = 0
	
	for item in get_inventory_contents():
		if item.type == item_type:
			item_count += 1
	
	return item_count


func carry_weight_left() -> float:
	return _main_inventory.capacity_left()


func interact_with(structure: Node2D):
	if _in_range(structure):
		structure.operate()




func _get_input() -> Array:
	var commands: Array = [ ]
	
#	if Input.is_action_pressed("open_menu"):
#		commands.append(MenuCommand.new())
	
#	if Input.is_action_pressed("interact"):
#		commands.append(InteractCommand.new(hit_box.currently_highlighting))
#		#get_tree().set_input_as_handled()
	
	var movement_vector: Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	var sprinting = Input.is_action_pressed("sprint")
	
	commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands



func _in_range(object: PhysicsBody2D) -> bool:
	return get_overlapping_bodies().has(object)





class Command:
	func execute(_state_machine: ObjectStateMachine):
		pass



class MoveCommand extends Command:
	var movement_vector: Vector2
	var sprinting: bool
	
	func _init(new_movement_vector: Vector2, new_sprinting: bool = false):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
	
	func execute(state_machine: ObjectStateMachine):
		state_machine.move_to(movement_vector, sprinting)



class GiveCommand extends Command:
	var what_to_give: GameResource
	var whom_to_give_to: Node2D
	
	func _init(new_what_to_give: GameResource, new_whom_to_give_to: Node2D):
		what_to_give = new_what_to_give
		whom_to_give_to = new_whom_to_give_to
	
	func execute(state_machine: ObjectStateMachine):
		state_machine.give_item(what_to_give, whom_to_give_to)



class TakeCommand extends Command:
	var what_to_take: GameResource
	
	func _init(new_what_to_take: GameResource):
		what_to_take = new_what_to_take
	
	func execute(state_machine: ObjectStateMachine):
		state_machine.take_item(what_to_take)


class RequestCommand extends Command:
	var request
	var whom_to_ask: Node2D
	
	func _init(new_request, new_whom_to_ask: Node2D):
		request = new_request
		whom_to_ask = new_whom_to_ask
	
	func execute(state_machine: ObjectStateMachine):
		state_machine.request_item(request, whom_to_ask)


class AttackCommand extends Command:
	var weapon: CraftTool
	
	func _init(new_weapon: CraftTool):
		weapon = new_weapon
	
	func execute(state_machine: ObjectStateMachine):
		state_machine.attack(weapon)


class InteractCommand extends Command:
	var structure: Node2D
	
	func _init(new_structure: Node2D):
		structure = new_structure
	
	func execute(state_machine: ObjectStateMachine):
		state_machine.operate(structure)



class MenuCommand extends Command:
	func execute(state_machine: ObjectStateMachine):
		state_machine.open_menu(RadiantUI.new(["Stockpile", "Woodcutters Hut"], state_machine))
