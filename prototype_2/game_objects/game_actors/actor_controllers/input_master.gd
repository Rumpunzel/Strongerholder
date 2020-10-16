class_name InputMaster, "res://assets/icons/game_actors/icon_input_master.svg"
extends Area2D



func process_commands(state_machine: StateMachine):
	#object_of_interest, null, global_position, _current_path
	var commands: Array = _get_input()
	
	for command in commands:
		command.execute(state_machine)



func _get_input() -> Array:
	var commands: Array = [ ]
	
#	if Input.is_action_pressed("open_menu"):
#		commands.append(MenuCommand.new())
	
#	if Input.is_action_pressed("interact"):
#		commands.append(InteractCommand.new(hit_box.currently_highlighting))
#		#get_tree().set_input_as_handled()
	
	var movement_vector: Vector2 = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	var sprinting = Input.is_action_pressed("sprint")
	
	#commands.append(MoveCommand.new(movement_vector, sprinting))
	
	return commands





class Command:
	func execute(_state_machine: StateMachine):
		assert(false)



class MoveCommand extends Command:
	var movement_vector: Vector2
	var sprinting: bool
	
	func _init(new_movement_vector: Vector2, new_sprinting: bool = false):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
	
	func execute(state_machine: StateMachine):
		state_machine.move_to(movement_vector, sprinting)



class GiveCommand extends Command:
	var what_to_give: GameResource
	var whom_to_give_to: Node2D
	
	func _init(new_what_to_give: GameResource, new_whom_to_give_to: Node2D):
		what_to_give = new_what_to_give
		whom_to_give_to = new_whom_to_give_to
	
	func execute(state_machine: StateMachine):
		state_machine.give_item(what_to_give, whom_to_give_to)



class TakeCommand extends Command:
	var what_to_take: GameResource
	
	func _init(new_what_to_take: GameResource):
		what_to_take = new_what_to_take
	
	func execute(state_machine: StateMachine):
		state_machine.take_item(what_to_take)



class AttackCommand extends Command:
	var weapon: CraftTool
	
	func _init(new_weapon: CraftTool):
		weapon = new_weapon
	
	func execute(state_machine: StateMachine):
		state_machine.attack(weapon)



class MenuCommand extends Command:
	func execute(state_machine: StateMachine):
		state_machine.open_menu(RadiantUI.new(["Stockpile", "Woodcutters Hut"], state_machine))
