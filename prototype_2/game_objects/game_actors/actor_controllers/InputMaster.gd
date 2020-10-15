class_name InputMaster, "res://assets/icons/game_actors/icon_input_master.svg"
extends Area2D



func process_commands(state_machine: StateMachine):
	#object_of_interest, null, global_position, _current_path
	var commands: Array = _get_input()
	
	for command in commands:
		if command.execute(state_machine):
			break



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





class Command:
	func execute(_state_machine: StateMachine) -> bool:
		assert(false)
		return false



class MoveCommand extends Command:
	var movement_vector: Vector2
	var sprinting: bool
	
	func _init(new_movement_vector: Vector2, new_sprinting: bool = false):
		movement_vector = new_movement_vector
		sprinting = new_sprinting
		
	func execute(state_machine: StateMachine) -> bool:
		state_machine.move_to(movement_vector, sprinting)
		return false



class InteractCommand extends Command:
	var hit_box: ObjectHitBox
	
	func _init(new_hit_box: ObjectHitBox):
		hit_box = new_hit_box
	
	func execute(state_machine: StateMachine) -> bool:
		if hit_box:
			state_machine.interact_with(hit_box)
			return true
		else:
			return false



class GiveCommand extends Command:
	var receiver: Object
	var what_to_give: Object
	
	func _init(new_receiver: Object, new_what_to_give: Object):
		receiver = new_receiver
		what_to_give = new_what_to_give
	
	func execute(state_machine: StateMachine) -> bool:
		state_machine.give_item_to(receiver, what_to_give)
		return true



class AttackCommand extends Command:
	var target: Object
	var weapon: CraftTool
	
	func _init(new_target: Object, new_weapon: CraftTool):
		target = new_target
		weapon = new_weapon
	
	func execute(state_machine: StateMachine) -> bool:
		state_machine.attack(target, weapon)
		return true



class MenuCommand extends Command:
	func execute(state_machine: StateMachine) -> bool:
		state_machine.open_menu(RadiantUI.new(["Stockpile", "Woodcutters Hut"], state_machine))
		return true
