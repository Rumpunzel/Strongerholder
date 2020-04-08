class_name GameActor
extends GameObject


signal new_interest(object_of_interest)
signal acquired_target(currently_searching_for)


const INTERACTION: String = "interaction"
const PARAMETERS: String = "parameters"
const BASIC_INTERACTION: Dictionary = { INTERACTION: INTERACT_FUNCTION }


var object_of_interest: GameObject = null setget set_object_of_interest, get_object_of_interest
var currently_searching_for = null setget set_currently_searching_for, get_currently_searching_for


onready var body: KinematicBody = $body
onready var behavior: ActorBehavior = $behavior
onready var animation_tree: AnimationTree = $animation_tree
onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")




func _ready():
	$pathfinder.register_actor(self)
	
	acquire_new_target()




func setup(new_ring_map: RingMap):
	.setup(new_ring_map)
	
	$pathfinder.ring_map = ring_map


func listen_to_commands(new_commands):
	for command in new_commands:
		if command.execute(self):
			break


func move_to(direction: Vector3, sprinting: bool = false):
	.set_ring_vector(body.move_to(direction, sprinting))


func interaction_with(object: GameObject) -> Dictionary:
	if object:
		var interaction: Dictionary = BASIC_INTERACTION
		var animation: String = "give"
		
		match object.type:
			CityLayout.Objects.FOUNDATION:
				var new_menu = RadiantUI.new(["Build", "Inspect", "Destroy"], object, "build_into")
				animation_tree.set("parameters/conditions/outside_menu", false)
				new_menu.connect("closed", animation_tree, "set", ["parameters/conditions/outside_menu", true])
				get_viewport().get_camera().add_ui_element(new_menu)
			
			CityLayout.Objects.TREE:
				animation = "attack"
				interaction = { INTERACTION: DAMAGE_FUNCTION, PARAMETERS: [ 2.0, 0.3 ] }
			
			CityLayout.Objects.STOCKPILE:
				if not inventory.empty():
					interaction = { INTERACTION: GIVE_FUNCTION, PARAMETERS: [ inventory ] }
		
		animate(animation)
		
		return interaction
	
	return { }


func animate(animation: String, stop_movement: bool = true):
	state_machine.travel(animation)
	
	if stop_movement:
		move_to(Vector3())


func acquire_new_target():
	set_currently_searching_for(behavior.next_priority(inventory))


func can_act() -> bool:
	var state: String = state_machine.get_current_node()
	var is_idle: bool = state.ends_with("idle") or state == "run"
	
	if is_idle:
		acquire_new_target()
	
	return is_idle




func set_object_of_interest(new_object: GameObject):
	if not new_object == object_of_interest:
		object_of_interest = new_object
		emit_signal("new_interest", object_of_interest)


func set_currently_searching_for(new_interest):
	if not new_interest == currently_searching_for:
		currently_searching_for = new_interest
		emit_signal("acquired_target", currently_searching_for)


func set_ring_vector(new_vector: RingVector):
	$body.ring_vector = new_vector
	.set_ring_vector($body.ring_vector)



func get_object_of_interest() -> GameObject:
	return object_of_interest

func get_currently_searching_for():
	return currently_searching_for

func get_ring_vector() -> RingVector:
	return $body.ring_vector
