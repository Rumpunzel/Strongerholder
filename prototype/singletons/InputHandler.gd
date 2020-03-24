extends PuppetMaster



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func get_input() -> Command:
	if Input.is_action_just_pressed("jump"):
		return JumpCommand.new()
	
	#if Input.is_action_just_released("jump"):
	#	return StopJumpCommand.new()
	
	var move_direction:Vector2 = Vector2(Input.get_action_strength("move_down") - Input.get_action_strength("move_up"), Input.get_action_strength("move_right") - Input.get_action_strength("move_left"))
	if move_direction.length() > 0:
		var sprinting = Input.is_action_pressed("sprint")
		return MoveCommand.new(move_direction, sprinting)
	
	return null



class StopJumpCommand extends PuppetMaster.Command:
	func execute(actor:GameActor):
		actor.stop_jump()
