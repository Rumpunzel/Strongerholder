class_name GameActor
extends RingObject


var can_act: bool = true setget set_can_act, get_can_act


var pathfinder: PuppetMaster
var player_controlled: int = -1 setget , get_player_controlled

var object_scenes: Dictionary = {
	Constants.Objects.PLAYER: load("res://game_objects/game_actors/game_character.tscn"),
	Constants.Objects.WOODSMAN: load("res://game_objects/game_actors/game_character.tscn"),
	Constants.Objects.CARPENTER: load("res://game_objects/game_actors/game_character.tscn"),
}




func _init(new_type: int, new_ring_vector: RingVector, new_ring_map: RingMap, new_inventory = [ ], controlling_player: int = 0).(new_type, new_ring_vector, new_ring_map):
	if type == Constants.Objects.PLAYER:
		controlling_player = 1
	
	set_player_controlled(controlling_player)
	
	receive_items(new_inventory, null)


func _ready():
	set_object(object_scenes[type].instance())




func listen_to_commands(new_commands):
	for command in new_commands:
		if command.execute(self):
			break


func move_to(direction: Vector3, sprinting: bool = false):
	.set_ring_vector(object.move_to(direction, sprinting))


func animate(animation: String, stop_movement: bool = true):
	object.animate(animation, stop_movement)


func is_in_range(object_of_interest) -> bool:
	return object.is_in_range(object_of_interest)




func set_player_controlled(new_player: int):
	if not new_player == player_controlled:
		if pathfinder:
			pathfinder.queue_free()
		
		if new_player > 0 and player_controlled <= 0:
			pathfinder = InputMaster.new(ring_map, self)
		else:
			pathfinder = PuppetMaster.new(ring_map, self)
		
		add_child(pathfinder)
		
		player_controlled = new_player


func set_can_act(new_status: bool):
	can_act = new_status

func set_ring_vector(new_vector: RingVector):
	if object:
		object.ring_vector = new_vector
		.set_ring_vector(object.ring_vector)
	else:
		.set_ring_vector(new_vector)

func set_object_of_interest(new_object: RingObject):
	pathfinder.set_object_of_interest(new_object, false)



func get_player_controlled() -> int:
	return player_controlled

func get_can_act() -> bool:
	if object and can_act:
		return object.is_idle()
	else:
		return can_act

func get_ring_vector() -> RingVector:
	return object.ring_vector if object else null

func get_object_of_interest() -> RingObject:
	return pathfinder.object_of_interest

func is_looking_for() -> int:
	return pathfinder.get_currently_looking_for()
